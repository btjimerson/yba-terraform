terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
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
  alias                  = "gke_cluster_1"
  cluster_ca_certificate = base64decode(module.gke_clusters[0].cluster_ca_certificate)
  host                   = "https://${module.gke_clusters[0].cluster_endpoint}"
  token                  = module.gke_clusters[0].cluster_token
}

provider "kubernetes" {
  alias                  = "gke_cluster_2"
  cluster_ca_certificate = base64decode(module.gke_clusters[1].cluster_ca_certificate)
  host                   = "https://${module.gke_clusters[1].cluster_endpoint}"
  token                  = module.gke_clusters[1].cluster_token
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

# Create YBA prerequisites on cluster 1
module "yba_prerequisites_cluster_1" {
  source     = "./modules/yba-prerequisites"
  depends_on = [module.gke_clusters]
  providers = {
    kubernetes = kubernetes.gke_cluster_1
  }
  istio_namespace                          = var.istio_namespace
  universe_management_cluster_role_binding = var.universe_management_cluster_role_binding
  universe_management_sa                   = var.universe_management_sa
  universe_namespace                       = var.subnets[1].region
  yba_namespace                            = var.yba_namespace
}

# Create YBA prerequisites on cluster 2
module "yba_prerequisites_cluster_2" {
  source     = "./modules/yba-prerequisites"
  depends_on = [module.gke_clusters]
  providers = {
    kubernetes = kubernetes.gke_cluster_2
  }
  istio_namespace                          = var.istio_namespace
  universe_management_cluster_role_binding = var.universe_management_cluster_role_binding
  universe_management_sa                   = var.universe_management_sa
  universe_namespace                       = var.subnets[1].region
  yba_namespace                            = var.yba_namespace
}

# Install YBA on cluster 1
module "yba" {
  source = "./modules/yba"
  providers = {
    kubernetes = kubernetes.gke_cluster_1
  }
  depends_on              = [module.yba_prerequisites_cluster_1]
  enable_yba_tls          = var.enable_yba_tls
  image_registry_email    = var.image_registry_email
  image_registry_password = var.image_registry_password
  image_registry_server   = var.image_registry_server
  image_registry_username = var.image_registry_username
  gke_cluster_name        = module.gke_clusters[0].cluster_name
  gcp_project_id          = var.gcp_project_id
  gcp_region              = var.subnets[0].region
  yba_namespace           = var.yba_namespace
  yba_version             = var.yba_version
}
