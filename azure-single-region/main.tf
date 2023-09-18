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

# Resource group
resource "azurerm_resource_group" "yb_resource_group" {
  name     = "${var.resource_prefix}-rg"
  location = var.resource_group_region

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
resource "azurerm_virtual_network" "yb_vnet" {
  name                = "${var.resource_prefix}-vnet"
  resource_group_name = azurerm_resource_group.yb_resource_group.name
  location            = azurerm_resource_group.yb_resource_group.location
  address_space       = [var.vnet_cidr_block]

  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}

# Subnet for YBA
resource "azurerm_subnet" "yba_subnet" {
  depends_on           = [azurerm_virtual_network.yb_vnet]
  name                 = "${var.resource_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.yb_resource_group.name
  virtual_network_name = azurerm_virtual_network.yb_vnet.name
  address_prefixes     = [var.yba_subnet_cidr]
}

# Subnets for YB universes
resource "azurerm_subnet" "universe_subnets" {
  for_each             = var.universe_subnets
  depends_on           = [azurerm_virtual_network.yb_vnet]
  name                 = "${var.resource_prefix}-universe-subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.yb_resource_group.name
  virtual_network_name = azurerm_virtual_network.yb_vnet.name
  address_prefixes     = [each.value]
}

# Public IP address for YBA
resource "azurerm_public_ip" "yba_public_ip" {
  name                = "${var.resource_prefix}-public-ip"
  resource_group_name = azurerm_resource_group.yb_resource_group.name
  location            = azurerm_resource_group.yb_resource_group.location
  zones               = [var.virtual_machine_zone]
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
  location            = azurerm_resource_group.yb_resource_group.location

  ip_configuration {
    name                          = "private-network-interface"
    subnet_id                     = azurerm_subnet.yba_subnet.id
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
  location            = azurerm_resource_group.yb_resource_group.location

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
    name                       = "yba-ui"
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
    name                       = "replicated-ui"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = var.yba_nsg_source_cidr
    destination_port_range     = "8800"
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
  subnet_id                 = azurerm_subnet.yba_subnet.id
  network_security_group_id = azurerm_network_security_group.yba_nsg.id
}

# Script to run on startup
locals {
  replicated_script = <<-EOL
  #!/bin/bash -xe
  curl -sSL https://get.replicated.com/docker | sudo bash
  curl -sSL https://downloads.yugabyte.com/get_clients.sh | bash
  EOL
}

# VM for YBA
resource "azurerm_linux_virtual_machine" "yba_vm" {
  name                  = "${var.resource_prefix}-vm"
  resource_group_name   = azurerm_resource_group.yb_resource_group.name
  location              = azurerm_resource_group.yb_resource_group.location
  zone                  = var.virtual_machine_zone
  size                  = var.virtual_machine_size
  admin_username        = var.admin_username
  user_data             = base64encode(local.replicated_script)
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
