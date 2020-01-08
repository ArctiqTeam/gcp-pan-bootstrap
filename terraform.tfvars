# GCP Project Vars
gcp_project_id = "your_gcp_project_id"
gcp_credentials = "/path_to/your_gcp_serviceaccount.json"

# Bootstrap vars
bootstrap_bucket  = "your_bootstrap_bucketname"
bootstrap_bucket_admin = "your_gcs_admin@your_gcporg.com"
bootstrap_folders = ["config/", "software/", "license/", "content/"]

# PAN Vars
pan_fw_image =   "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-byol-904"
untrust_ip     = "10.5.1.4"
management_source_ips = ["0.0.0.0/0"]

# PAN Vars - demo only based on a Web and DB server(s) being deployed
db_subnet      = "10.5.3.0/24"
trust_ip_web   = "10.5.2.4"
trust_ip_db    = "10.5.3.4"
