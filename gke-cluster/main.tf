data "google_client_config" "default" {}

terraform {
  backend "gcs" {
    bucket = "bjimerson-tf-backend"
    prefix = "bjimerson-gke-cluster"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.cluster.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.cluster.endpoint}"
    cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.resource_prefix}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.resource_prefix}-subnet"
  region        = var.region
  project       = var.project_id
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.subnet_cidr
}

# GKE cluster
resource "google_container_cluster" "cluster" {
  name                     = "${var.resource_prefix}-cluster"
  location                 = var.region
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name
  initial_node_count       = 1
  remove_default_node_pool = true
  provider                 = google

}

# Default node pool
resource "google_container_node_pool" "primary_node_pool" {
  name       = google_container_cluster.cluster.name
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = var.node_pool_size
  provider   = google

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    machine_type = var.node_pool_machine_type
    disk_size_gb = var.node_pool_disk_size
    disk_type    = var.node_pool_disk_type
    metadata = {
      disable-legacy-endpoints = true
    }
    labels = {
      "yb_owner"       = var.owner_tag_value
      "yb_dept"        = var.department_tag_value
      "yb_task"        = var.task_tag_value
      "yb_customer"    = var.customer_tag_value
      "yb_salesregion" = var.sales_region_tag_value
    }
  }
}

# Kubeconfig
module "gke_auth" {
  source     = "terraform-google-modules/kubernetes-engine/google/modules/auth"
  depends_on = [google_container_cluster.cluster]

  project_id   = var.project_id
  location     = google_container_cluster.cluster.location
  cluster_name = google_container_cluster.cluster.name
}

# YBA
module "yba" {
  source                                       = "./modules/yba"
  depends_on                                   = [google_container_cluster.cluster]
  image_registry_email                         = var.image_registry_email
  image_registry_password                      = var.image_registry_password
  image_registry_server                        = var.image_registry_server
  image_registry_username                      = var.image_registry_username
  yba_namespace                                = var.yba_namespace
  yba_role                                     = var.yba_role
  yba_role_binding                             = var.yba_role_binding
  yba_sa                                       = var.yba_sa
  yba_universe_management_cluster_role         = var.yba_universe_management_cluster_role
  yba_universe_management_cluster_role_binding = var.yba_universe_management_cluster_role_binding
  yba_universe_management_namespace            = var.yba_universe_management_namespace
  yba_universe_management_sa                   = var.yba_universe_management_sa
  yba_version                                  = var.yba_version
}

