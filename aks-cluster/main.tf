terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
  }
}

# AKS cluster data
data "azurerm_kubernetes_cluster" "aks_cluster" {
  depends_on          = [azurerm_kubernetes_cluster.aks_cluster]
  name                = local.aks_cluster_name
  resource_group_name = local.resource_group_name
}

# Configure Azure provider
provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# Configure Kubernetes provider
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
}

# Configure Helm provider
provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
  }
}

# Local variables
locals {
  resource_group_name = "${var.resource_prefix}-rg"
  aks_cluster_name    = "${var.resource_prefix}-cluster"
}

# AKS resource group
resource "azurerm_resource_group" "aks_resource_group" {
  name     = local.resource_group_name
  location = var.region
  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}

# SSH public key for AKS
resource "azapi_resource" "ssh_public_key" {
  depends_on = [azurerm_resource_group.aks_resource_group]
  type       = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name       = "${local.aks_cluster_name}-ssh-key"
  location   = azurerm_resource_group.aks_resource_group.location
  parent_id  = azurerm_resource_group.aks_resource_group.id
}

# SSH key pair for AKS
resource "azapi_resource_action" "ssh_public_key_gen" {
  depends_on  = [azapi_resource.ssh_public_key]
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

# AKS cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  depends_on          = [azapi_resource_action.ssh_public_key_gen]
  location            = azurerm_resource_group.aks_resource_group.location
  name                = local.aks_cluster_name
  resource_group_name = azurerm_resource_group.aks_resource_group.name
  dns_prefix          = "${local.aks_cluster_name}-dns"
  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "nodepool"
    vm_size    = var.node_size
    node_count = var.node_count
  }
  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

# YBA
module "yba" {
  source                                       = "./modules/yba"
  depends_on                                   = [azurerm_kubernetes_cluster.aks_cluster]
  yba_namespace                                = var.yba_namespace
  yba_pull_secret                              = var.yba_pull_secret
  yba_role                                     = var.yba_role
  yba_role_binding                             = var.yba_role_binding
  yba_sa                                       = var.yba_sa
  yba_universe_management_cluster_role         = var.yba_universe_management_cluster_role
  yba_universe_management_cluster_role_binding = var.yba_universe_management_cluster_role_binding
  yba_universe_management_namespace            = var.yba_universe_management_namespace
  yba_universe_management_sa                   = var.yba_universe_management_sa
  yba_version                                  = var.yba_version
}

