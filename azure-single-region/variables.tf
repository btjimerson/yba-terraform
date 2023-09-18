variable "admin_ssh_key" {
  description = "The public SSH key for the admin user."
  type        = string
}

variable "admin_username" {
  description = "The username for the SSH admin user."
  type        = string
}

variable "customer_tag_value" {
  description = "The value for the customer tag for resources."
  type        = string
}

variable "department_tag_value" {
  description = "The value for the department tag for resources."
  type        = string
}

variable "owner_tag_value" {
  description = "The value for the owner tag for resources"
  type        = string
}

variable "resource_group_region" {
  description = "The Azure region for the resource group and all resrouces"
  type        = string
  default     = "eastus"
}

variable "resource_prefix" {
  description = "Prefix to use for all resource names."
  type        = string
}

variable "sales_region_tag_value" {
  description = "The value for the sales region tag for resources"
  type        = string
}

variable "subscription_id" {
  description = "The subscription ID to use for Azure resources"
  type        = string
}

variable "task_tag_value" {
  description = "The value for the task tag for resources"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID of the Azure subscription"
  type        = string
}

variable "universe_subnets" {
  description = "Subnets to create for YB universes. Each subnet should have a CIDR range in the vnet_cidr_block. The key is made part of the subnet name."
  type        = map(string)
  default = {
    "1" = "10.0.2.0/24",
    "2" = "10.0.3.0/24",
    "3" = "10.0.4.0/24"
  }
}

variable "virtual_machine_size" {
  description = "The size of the VM for YBA."
  type        = string
  default     = "Standard_D8s_v3"
}

variable "virtual_machine_zone" {
  description = "The zone to create the YBA VM in."
  type        = string
  default     = "1"
}

variable "vnet_cidr_block" {
  description = "The CIDR block for the virtual network. This should be large enough to hold the YBA and universe subnets."
  type        = string
  default     = "10.0.0.0/16"
}

variable "yba_nsg_source_cidr" {
  description = "The source CIDR block of external access for the YBA network security group. This is probably your IP address."
  type        = string
}

variable "yba_disk_size" {
  description = "The size of disk for the YBA VM (in GB)"
  type        = string
  default     = "100"

}

variable "yba_disk_type" {
  description = "The type of disk for the YBA VM"
  type        = string
  default     = "Premium_LRS"
}

variable "yba_source_image_offer" {
  description = "The offer for the YBA VM source image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "yba_source_image_publisher" {
  description = "The publisher of the YBA VM source image"
  type        = string
  default     = "Canonical"
}

variable "yba_source_image_sku" {
  description = "The SKU for the YBA VM source image"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "yba_source_image_version" {
  description = "The version of the YBA VM source image"
  type        = string
  default     = "latest"
}

variable "yba_subnet_cidr" {
  description = "The CIDR block for the YBA subnet"
  type        = string
  default     = "10.0.1.0/24"
}
