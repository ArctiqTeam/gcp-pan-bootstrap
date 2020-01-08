# GCP Vars
variable "gcp_project_id" {}
variable "gcp_credentials" {}
variable "zone" {
    default = "us-central1-a"
}
variable "region" {
    default = "us-central1"
}

# PAN Vars
variable "bootstrap_bucket" {}
variable "bootstrap_bucket_admin" {}
variable "bootstrap_folders" {
    default = ["config/", "software/", "license/", "content/"]
}
variable "pan_fw_name" {
    default = "pan-vm-series"
}
variable "pan_fw_image" {
     # default = "Your_VM_Series_Image"
  
  # /Cloud Launcher API Calls to images/
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-byol-810"
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle2-810"
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle1-810"

}
variable "pan_int_0_name" { 
    default = "management"
}
variable "pan_int_1_name" {
    default = "untrust"
}

variable "pan_int_2_name" {
    default = "trust-web"
}

variable "pan_int_3_name" {
    default = "trust-db"
}

variable "pan_machine_type" { 
    default = "n1-standard-4"
}

variable "pan_cpu" { 
    default = "Intel Skylake"
}

variable "pan_scopes" {
  default = ["https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}

variable "db_subnet" {}
variable "management_source_ips" {}
variable "trust_ip_db" {}
variable "untrust_ip" {}
variable "trust_ip_web" {}
