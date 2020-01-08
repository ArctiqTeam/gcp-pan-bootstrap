# GCP Project Vars
gcp_project_id = "p-teckresources-tfe"
gcp_credentials = "/home/mleblanc/secrets/p-tr-tfe.json"

# Bootstrap vars
bootstrap_bucket  = "pan_bootstrapaa"
bootstrap_bucket_admin = "marc.leblanc@arctiq.ca"
bootstrap_folders = ["config/", "software/", "license/", "content/"]

# PAN Vars
pan_fw_image =   "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-byol-904"
#management_ip  = "10.5.1.4"
untrust_ip     = "10.5.1.4"
management_source_ips = ["0.0.0.0/0"]

# PAN Vars - demo only based on a Web and DB server(s) being deployed
db_subnet      = "10.5.3.0/24"
trust_ip_web   = "10.5.2.4"
trust_ip_db    = "10.5.3.4"
