terraform {
  required_providers {
    yba = {
      source  = "yugabyte/yba"
      version = "0.1.9"
    }
  }
}

# Configure the google provider
provider "google" {
  project = var.gcp_project_id
  default_labels = {
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(module.gke_clusters[0].cluster_ca_certificate)
  host                   = "https://${module.gke_clusters[0].cluster_endpoint}"
  token                  = module.gke_clusters[0].cluster_token
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(module.gke_clusters[0].cluster_ca_certificate)
    host                   = "https://${module.gke_clusters[0].cluster_endpoint}"
    token                  = module.gke_clusters[0].cluster_token
  }
}

provider "yba" {
  alias = "unauthenticated"
  host  = module.yba.yba_hostname
}

# Create the VPC and subnets
module "google_vpc" {
  source          = "./modules/google-vpc"
  resource_prefix = var.resource_prefix
  subnets         = var.subnets
}

# Create the GKE clusters
module "gke_clusters" {
  source             = "./modules/google-gke"
  depends_on         = [module.google_vpc]
  count              = length(var.subnets)
  kubernetes_version = var.kubernetes_version
  node_machine_type  = var.node_machine_type
  number_of_nodes    = var.number_of_nodes
  region             = var.subnets[count.index].region
  resource_prefix    = var.resource_prefix
  subnet_self_link   = module.google_vpc.subnets_self_link[count.index]
  vpc_self_link      = module.google_vpc.vpc_self_link
}

# Install YBA
module "yba" {
  source                                   = "./modules/yba"
  depends_on                               = [module.gke_clusters]
  universe_management_cluster_role         = var.universe_management_cluster_role
  universe_management_cluster_role_binding = var.universe_management_cluster_role_binding
  universe_management_namespace            = var.universe_management_namespace
  universe_management_sa                   = var.universe_management_sa
  yba_namespace                            = var.yba_namespace
  yba_pull_secret                          = base64encode(var.yba_pull_secret)
  yba_version                              = var.yba_version
}

# Configure YBA
module "yba-universe" {
  source     = "./modules/yba-universe"
  depends_on = [module.yba]
  providers = {
    yba.unauthenticated = yba.unauthenticated
  }
  yba_admin_email = var.yba_admin_email
  yba_admin_name  = var.yba_admin_name
}
