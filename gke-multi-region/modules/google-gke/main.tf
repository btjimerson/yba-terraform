terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.3.0"
    }
  }
}

locals {
  cluster_name = "${var.resource_prefix}-${var.region}-gke"
}

# Get the client config
data "google_client_config" "provider" {}

# Create the GKE cluster
resource "google_container_cluster" "gke_cluster" {
  deletion_protection      = false
  initial_node_count       = 1
  location                 = var.region
  name                     = local.cluster_name
  remove_default_node_pool = true
  network                  = var.vpc_self_link
  subnetwork               = var.subnet_self_link
}

# Create a managed GKE node pool
resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.gke_cluster.name
  location   = var.region
  name       = google_container_cluster.gke_cluster.name
  node_count = var.number_of_nodes
  version    = var.kubernetes_version

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    machine_type = var.node_machine_type
    tags         = ["gke-node", "${var.resource_prefix}-${var.region}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
