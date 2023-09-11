terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Provider configuration
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "yba_resource_group" {
  name     = "${var.resource_prefix}-rg"
  location = var.resource_group_region

  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}

# VNET for YBA
resource "azurerm_virtual_network" "yba_vnet" {
  name                = "${var.resource_prefix}-vnet"
  resource_group_name = azurerm_resource_group.yba_resource_group.name
  location            = azurerm_resource_group.yba_resource_group.location
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
  name                 = "${var.resource_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.yba_resource_group.name
  virtual_network_name = azurerm_virtual_network.yba_vnet.name
  address_prefixes     = [var.subnet_cidr_block]
}

# Public IP address
resource "azurerm_public_ip" "yba_public_ip" {
  name                = "${var.resource_prefix}-public-ip"
  resource_group_name = azurerm_resource_group.yba_resource_group.name
  location            = azurerm_resource_group.yba_resource_group.location
  zones               = ["1"]
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
  resource_group_name = azurerm_resource_group.yba_resource_group.name
  location            = azurerm_resource_group.yba_resource_group.location

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
  name                = "${var.resource_prefix}-nsg"
  resource_group_name = azurerm_resource_group.yba_resource_group.name
  location            = azurerm_resource_group.yba_resource_group.location

  security_rule {
    name                       = "ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = var.nsg_source_cidr
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = var.nsg_source_cidr
    destination_port_range     = "80"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "replicated"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = var.nsg_source_cidr
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
  EOL
}

# VM for YBA
resource "azurerm_linux_virtual_machine" "yba_vm" {
  name                  = "${var.resource_prefix}-vm"
  resource_group_name   = azurerm_resource_group.yba_resource_group.name
  location              = azurerm_resource_group.yba_resource_group.location
  zone                  = var.virtual_machine_zone
  size                  = var.virtual_machine_size
  admin_username        = var.admin_username
  user_data             = base64encode(local.replicated_script)
  network_interface_ids = [azurerm_network_interface.yba_network_interface.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.disk_type
    disk_size_gb         = var.disk_size
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }

  tags = {
    yb_owner    = var.owner_tag_value
    yb_dept     = var.department_tag_value
    yb_task     = var.task_tag_value
    yb_customer = var.customer_tag_value
  }
}
