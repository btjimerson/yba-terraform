data "google_client_config" "default" {}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "yba" {
  alias = "unauthenticated"
  host  = google_compute_instance.yba_instance.network_interface.0.access_config.0.nat_ip
}

provider "yba" {
  host      = google_compute_instance.yba_instance.network_interface.0.access_config.0.nat_ip
  api_token = yba_customer_resource.yba_admin.api_token
}

terraform {
  #backend "gcs" {
  #  bucket = "bjimerson-tf-backend"
  #  prefix = "bjimerson-gcp-single-region"
  #}
  required_providers {
    yba = {
      source  = "yugabyte/yba"
      version = "0.1.11"
    }
  }
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.resource_prefix}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
}

# YBA subnet
resource "google_compute_subnetwork" "yba_subnet" {
  name          = "${var.resource_prefix}-yba-subnet"
  region        = var.region
  project       = var.project_id
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.yba_subnet_cidr
}

# Universe subnet
resource "google_compute_subnetwork" "universe_subnet" {
  name          = "${var.resource_prefix}-universe-subnet"
  region        = var.region
  project       = var.project_id
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.universe_subnet
}

# YBA firewall
resource "google_compute_firewall" "yba_firewall" {
  name     = "${var.resource_prefix}-yba-firewall"
  network  = google_compute_network.vpc.name
  priority = 1000
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "9000"]
  }
  source_ranges = [var.yb_allowed_source_range]
}

# YBA -> nodes communication firewall
resource "google_compute_firewall" "yba_to_yb_nodes_firewall" {
  name     = "${var.resource_prefix}-yba-to-yb-nodes-firewall"
  network  = google_compute_network.vpc.name
  priority = 1100
  allow {
    protocol = "tcp"
    ports    = ["22", "7000", "7100", "9000", "9070", "9100", "9300", "54422"]
  }
  source_tags = ["yba"]
}

# YB nodes API firewall
resource "google_compute_firewall" "yb_nodes_api_firewall" {
  name     = "${var.resource_prefix}-yb-nodes-api-firewall"
  network  = google_compute_network.vpc.name
  priority = 1200
  allow {
    protocol = "tcp"
    ports    = ["5433", "9042"]
  }
  source_ranges = [var.yb_allowed_source_range]
}

# YBA compute instance
resource "google_compute_instance" "yba_instance" {
  name         = "${var.resource_prefix}-yba"
  machine_type = var.yba_instance_type
  zone         = var.yba_instance_zone
  tags         = ["yba"]
  labels = {
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
  boot_disk {
    initialize_params {
      image = var.yba_instance_image
      size  = var.yba_boot_disk_size
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.yba_subnet.name
    access_config {} # Adds ephemeral public ip to VM
  }

}

# YBA Installer
#resource "yba_installer" "yba" {
#  depends_on                = [google_compute_instance.yba_instance]
#  provider                  = yba.unauthenticated
#  ssh_host_ip               = google_compute_instance.yba_instance.network_interface.0.access_config.0.nat_ip
#  ssh_user                  = var.yba_ssh_admin_username
#  yba_license_file          = var.yba_license_file
#  application_settings_file = var.yba_settings_file == "" ? null : var.yba_settings_file
#  yba_version               = var.yba_version
#  ssh_private_key_file_path = var.yba_ssh_private_key_path
#}

# Admin user for YBA
# Make sure YB_CUSTOMER_PASSWORD environment variable is set
#resource "yba_customer_resource" "yba_admin" {
#  depends_on = [yba_installer.yba]
#  provider   = yba.unauthenticated
#  code       = "admin"
#  email      = var.yba_admin_email
#  name       = var.yba_admin_name
#}

