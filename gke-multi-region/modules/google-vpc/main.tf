terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.3.0"
    }
  }
}

# Create a VPC 
resource "google_compute_network" "vpc" {
  name                    = "${var.resource_prefix}-vpc"
  auto_create_subnetworks = false
}

# Create the subnets in the VPC
resource "google_compute_subnetwork" "subnets" {
  count         = length(var.subnets)
  depends_on    = [google_compute_network.vpc]
  name          = "${var.resource_prefix}-${var.subnets[count.index].region}-subnet"
  network       = google_compute_network.vpc.name
  region        = var.subnets[count.index].region
  ip_cidr_range = var.subnets[count.index].cidr_range
}
