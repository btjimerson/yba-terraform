terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.41.0"
    }
    yba = {
      source  = "yugabyte/yba"
      version = "0.1.8"
    }
  }
}

# Provider configurations
provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
provider "azuread" {
  tenant_id = var.tenant_id
}
provider "yba" {
  alias = "unauthenticated"
  host  = azurerm_public_ip.yba_public_ip.ip_address
}

data "azuread_client_config" "current" {}

# AD application registration
resource "azuread_application" "yba_application" {
  display_name = "${var.resource_prefix}-app"
  owners       = [data.azuread_client_config.current.object_id]
}

# Client secret for ad application
resource "azuread_application_password" "yba_application_password" {
  application_object_id = azuread_application.yba_application.object_id
}

# Service principal for ad application
resource "azuread_service_principal" "yba_application_sp" {
  application_id = azuread_application.yba_application.application_id
  owners         = [data.azuread_client_config.current.object_id]
}

# Yugabyte resource group
resource "azurerm_resource_group" "yb_resource_group" {
  name     = var.resource_group.name
  location = var.resource_group.region
  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}

# Application Network Contributor role for rg
resource "azurerm_role_assignment" "app_network_contributor_role_assignment" {
  scope                = azurerm_resource_group.yb_resource_group.id
  principal_id         = azuread_service_principal.yba_application_sp.id
  role_definition_name = "Network Contributor"
}

# Application Virtual Machine Contributor role for rg
resource "azurerm_role_assignment" "app_virtual_machine_contributor_role_assignment" {
  scope                = azurerm_resource_group.yb_resource_group.id
  principal_id         = azuread_service_principal.yba_application_sp.id
  role_definition_name = "Virtual Machine Contributor"
}

# VNET for YBA
resource "azurerm_virtual_network" "yba_vnet" {
  name                = var.yba_vnet.name
  resource_group_name = azurerm_resource_group.yb_resource_group.name
  location            = var.yba_vnet.region
  address_space       = [var.yba_vnet.vnet_cidr_block]

  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}

# Subnets for YBA
resource "azurerm_subnet" "yba_subnets" {
  depends_on           = [azurerm_virtual_network.yba_vnet]
  count                = length(var.yba_vnet.subnets)
  name                 = "${azurerm_virtual_network.yba_vnet.name}-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.yb_resource_group.name
  virtual_network_name = azurerm_virtual_network.yba_vnet.name
  address_prefixes     = [var.yba_vnet.subnets[count.index]]
}

# Public IP address for YBA
resource "azurerm_public_ip" "yba_public_ip" {
  name                = "${var.resource_prefix}-public-ip"
  resource_group_name = azurerm_resource_group.yb_resource_group.name
  location            = var.yba_vnet.region
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}

# Network interface for YBA VM
resource "azurerm_network_interface" "yba_network_interface" {
  name                = "${var.resource_prefix}-network-interface"
  resource_group_name = azurerm_resource_group.yb_resource_group.name
  location            = var.yba_vnet.region

  ip_configuration {
    name                          = "yba-network-interface"
    subnet_id                     = azurerm_subnet.yba_subnets[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.yba_public_ip.id
  }

  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}

# Network security group for YBA
resource "azurerm_network_security_group" "yba_nsg" {
  name                = "${var.resource_prefix}-yba-nsg"
  resource_group_name = azurerm_resource_group.yb_resource_group.name
  location            = var.yba_vnet.region

  security_rule {
    name                       = "ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = var.yba_nsg_source_cidr
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "yba-ui-http"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = var.yba_nsg_source_cidr
    destination_port_range     = "80"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "yba-ui-https"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = var.yba_nsg_source_cidr
    destination_port_range     = "443"
    destination_address_prefix = "*"
  }

  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}

# Association between subnet and nsg
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  count                     = length(azurerm_subnet.yba_subnets)
  depends_on                = [azurerm_subnet.yba_subnets, azurerm_network_security_group.yba_nsg]
  subnet_id                 = azurerm_subnet.yba_subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.yba_nsg.id
}

# Accept marketplace terms for VM image
resource "azurerm_marketplace_agreement" "yba_vm_agreement" {
  offer     = var.yba_source_image_offer
  plan      = var.yba_source_image_sku
  publisher = var.yba_source_image_publisher
}

# Script to run on startup
# Installs YB clients on YBA VM.  SSH into the YBA VM to interact with universes
locals {
  user_data_script = <<-EOL
  #!/bin/bash -xe
  curl -sSL https://downloads.yugabyte.com/get_clients.sh | bash
  EOL
}

# VM for YBA
resource "azurerm_linux_virtual_machine" "yba_vm" {
  depends_on            = [azurerm_marketplace_agreement.yba_vm_agreement]
  name                  = "${var.resource_prefix}-yba-vm"
  resource_group_name   = azurerm_resource_group.yb_resource_group.name
  location              = var.yba_vnet.region
  size                  = var.yba_virtual_machine_size
  admin_username        = var.admin_username
  user_data             = base64encode(local.user_data_script)
  network_interface_ids = [azurerm_network_interface.yba_network_interface.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.yba_disk_type
    disk_size_gb         = var.yba_disk_size
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key
  }

  source_image_reference {
    publisher = var.yba_source_image_publisher
    offer     = var.yba_source_image_offer
    sku       = var.yba_source_image_sku
    version   = var.yba_source_image_version
  }
  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}

# YBA Installer
resource "yba_installer" "yba" {
  depends_on                = [azurerm_linux_virtual_machine.yba_vm]
  provider                  = yba.unauthenticated
  ssh_host_ip               = azurerm_public_ip.yba_public_ip.ip_address
  ssh_user                  = var.admin_username
  yba_license_file          = var.yba_license_file
  application_settings_file = var.yba_settings_file == "" ? null : var.yba_settings_file
  yba_version               = var.yba_version
  ssh_private_key_file_path = var.ssh_private_key_path
}

# Admin user for YBA
# Make sure YB_CUSTOMER_PASSWORD environment variable is set
resource "yba_customer_resource" "yba_admin" {
  depends_on = [yba_installer.yba]
  provider   = yba.unauthenticated
  code       = "admin"
  email      = var.yba_admin_email
  name       = var.yba_admin_name
}

# VNETs for universes
resource "azurerm_virtual_network" "universe_vnets" {
  count               = length(var.universe_vnets)
  depends_on          = [azurerm_resource_group.yb_resource_group]
  name                = var.universe_vnets[count.index].name
  resource_group_name = azurerm_resource_group.yb_resource_group.name
  location            = var.universe_vnets[count.index].region
  address_space       = [var.universe_vnets[count.index].vnet_cidr_block]
  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}

# Create a list of universe subnets
locals {
  universe_subnets = distinct(flatten([
    for vnet in var.universe_vnets : [
      for subnet in vnet.subnets : {
        vnet   = vnet.name
        subnet = subnet
      }
    ]
  ]))
}

# Subnets for universes
resource "azurerm_subnet" "universe_subnets" {
  count                = length(local.universe_subnets)
  depends_on           = [azurerm_virtual_network.universe_vnets]
  name                 = "${local.universe_subnets[count.index].vnet}-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.yb_resource_group.name
  virtual_network_name = local.universe_subnets[count.index].vnet
  address_prefixes     = [local.universe_subnets[count.index].subnet]
}

# YBA - universe vnet peering
resource "azurerm_virtual_network_peering" "yba_universe_peerings" {
  count                     = length(azurerm_virtual_network.universe_vnets)
  depends_on                = [azurerm_virtual_network.universe_vnets, azurerm_virtual_network.yba_vnet]
  name                      = "${azurerm_virtual_network.yba_vnet.name}-${azurerm_virtual_network.universe_vnets[count.index].name}-peering"
  resource_group_name       = azurerm_resource_group.yb_resource_group.name
  virtual_network_name      = azurerm_virtual_network.yba_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.universe_vnets[count.index].id
}

# Universe - YBA vnet peering
resource "azurerm_virtual_network_peering" "universe_yba_peerings" {
  count                     = length(azurerm_virtual_network.universe_vnets)
  depends_on                = [azurerm_virtual_network.universe_vnets, azurerm_virtual_network.yba_vnet]
  name                      = "${azurerm_virtual_network.universe_vnets[count.index].name}-${azurerm_virtual_network.yba_vnet.name}-peering"
  resource_group_name       = azurerm_resource_group.yb_resource_group.name
  virtual_network_name      = azurerm_virtual_network.universe_vnets[count.index].name
  remote_virtual_network_id = azurerm_virtual_network.yba_vnet.id
}

# Create a list of universe vnet peerings
locals {
  universe_vnet_peerings = distinct(flatten([
    for vnet1 in var.universe_vnets : [
      for vnet2 in azurerm_virtual_network.universe_vnets : {
        local_vnet_name  = vnet1.name
        remote_vnet_name = vnet2.name
        remote_vnet_id   = vnet2.id
      } if vnet1.name != vnet2.name
    ]
  ]))
}

# Universe - universe vnet peerings
resource "azurerm_virtual_network_peering" "universe_universe_peerings" {
  count                     = length(local.universe_vnet_peerings)
  depends_on                = [azurerm_virtual_network.universe_vnets]
  name                      = "${local.universe_vnet_peerings[count.index].local_vnet_name}-${local.universe_vnet_peerings[count.index].remote_vnet_name}-peering"
  resource_group_name       = azurerm_resource_group.yb_resource_group.name
  virtual_network_name      = local.universe_vnet_peerings[count.index].local_vnet_name
  remote_virtual_network_id = local.universe_vnet_peerings[count.index].remote_vnet_id
}

