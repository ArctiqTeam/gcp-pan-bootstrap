provider "google" { 
    credentials = var.gcp_credentials
    version = "~> 2.17"
}

# GCS Bucket Work

module "bootstrap_bucket" {
  source  = "./modules/terraform-google-cloud-storage/"
  project_id  = var.gcp_project_id
  names = [var.bootstrap_bucket]
  prefix = ""
  set_admin_roles = true
  admins = [join("", ["user:",var.bootstrap_bucket_admin])]
  versioning = {
    first = true
  }
  bucket_admins = {
    second = "user:var.bootstrap_bucket_admin"
  }
}

resource "google_storage_bucket_object" "bootstrap_folders" {
  for_each = toset(var.bootstrap_folders)
  name          = each.value
  content       = "bootstrap folders"
  bucket        = module.bootstrap_bucket.name
}

resource "google_storage_bucket_object" "bootstrap_init_cfg" { 
    name = "config/init-cfg.txt"
    bucket = module.bootstrap_bucket.name
    source = "./assets/init-cfg.txt-dhcp"
}

resource "google_storage_bucket_object" "bootstrap_xml" {
  name  = "config/bootstrap.xml"
  bucket = module.bootstrap_bucket.name
  source = "./assets/bootstrap.xml"
}

# VPC Configuration

// Adding VPC Networks to Project  MANAGEMENT
resource "google_compute_subnetwork" "management-sub" {
  name          = "management-subnet"
  ip_cidr_range = "10.5.0.0/24"
  network       = "${google_compute_network.management.self_link}"
  region        = var.region
  project = var.gcp_project_id

}

# Untrust VPC setup
resource "google_compute_subnetwork" "untrust-sub" {
  name          = "untrust-subnet"
  ip_cidr_range = "10.5.1.0/24"
  network       = "${google_compute_network.untrust.self_link}"
  region        = var.region
  project = var.gcp_project_id

}

resource "google_compute_network" "untrust" {
  name                    = var.pan_int_1_name
  auto_create_subnetworks = "false"
  project = var.gcp_project_id
}


#  Web Trust VPC setup
resource "google_compute_subnetwork" "web-trust-sub" {
  name          = "web-subnet"
  ip_cidr_range = "10.5.2.0/24"
  network       = "${google_compute_network.web.self_link}"
  region        = var.region
  project       = var.gcp_project_id
}

resource "google_compute_network" "web" {
  name                    = var.pan_int_2_name
  auto_create_subnetworks = "false"
  project = var.gcp_project_id

}

resource "google_compute_network" "management" {
  name                    = var.pan_int_0_name
  auto_create_subnetworks = "false"
  project = var.gcp_project_id

}

# DB Trust VPC setup
resource "google_compute_subnetwork" "db-trust-sub" {
  name          = "db-subnet"
  ip_cidr_range = var.db_subnet
  network       = "${google_compute_network.db.self_link}"
  region        = var.region
  project = var.gcp_project_id

}

resource "google_compute_network" "db" {
  name                    = var.pan_int_3_name
  auto_create_subnetworks = "false"
  project = var.gcp_project_id

}

# Firewalls 
resource "google_compute_firewall" "allow-mgmt" {
  project = var.gcp_project_id

  name    = "allow-mgmt"
  network = "${google_compute_network.management.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["443", "22"]
  }

  source_ranges = var.management_source_ips
}

// Create a new Palo Alto Networks NGFW VM-Series GCE instance
resource "google_compute_instance" "firewall" {
  project                   = var.gcp_project_id
  name                      = var.pan_fw_name
  machine_type              = var.pan_machine_type
  zone                      = var.zone
  min_cpu_platform          = var.pan_cpu
  can_ip_forward            = true
  allow_stopping_for_update = true
  count                     = 1

  # Set metadata for bootstrap bucket
  metadata = {
    vmseries-bootstrap-gce-storagebucket = var.bootstrap_bucket
    serial-port-enable                   = true
   }

  service_account {
    scopes = var.pan_scopes
  }

  # Configure each network interface to attach to each respective VPC
  network_interface {
    subnetwork    = "${google_compute_subnetwork.management-sub.self_link}"
    access_config {}
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.untrust-sub.self_link}"
      network_ip    = var.untrust_ip
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.web-trust-sub.self_link}"
    network_ip    = var.trust_ip_web
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.db-trust-sub.self_link}"
    network_ip    = var.trust_ip_db
  }

  boot_disk {
    initialize_params {
      image = var.pan_fw_image
    }
  }
}

output "firewall-name" {
  value = "${google_compute_instance.firewall.*.name}"
}
