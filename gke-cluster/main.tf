data "google_client_config" "default" {}

provider "google-beta" {
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
  provider                 = google-beta

}

# Default node pool
resource "google_container_node_pool" "primary_node_pool" {
  name       = google_container_cluster.cluster.name
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = var.node_pool_size
  provider   = google-beta

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

# GKE hub membership for Anthos config management
resource "google_gke_hub_membership" "membership" {
  membership_id = "${var.resource_prefix}-membership"
  provider      = google-beta
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.cluster.id}"
    }
  }
}

# Anthos config managmement
resource "google_gke_hub_feature_membership" "feature_member" {
  location   = "global"
  membership = google_gke_hub_membership.membership.membership_id
  feature    = "configmanagement"
  provider   = google-beta
  configmanagement {
    config_sync {
      source_format = var.acm_config_sync_source_format
      git {
        sync_repo   = var.acm_git_repo
        sync_branch = var.acm_repo_branch
        secret_type = var.acm_repo_authentication
      }
    }
  }
}

# Credentials for Github sync
resource "kubernetes_secret" "git_creds" {
  depends_on = [google_gke_hub_feature_membership.feature_member]
  metadata {
    name      = "git-creds"
    namespace = var.acm_namespace
  }

  data = {
    username = var.acm_repo_username
    token    = var.acm_repo_pat
  }
}

# Kubeconfig
module "gke_auth" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on = [google_container_cluster.cluster]

  project_id   = var.project_id
  location     = google_container_cluster.cluster.location
  cluster_name = google_container_cluster.cluster.name
}

