variable "admin_ssh_key" {
  description = "The key for the SSH admin user"
  type        = string
}

variable "admin_username" {
  description = "The username for the SSH admin user"
  type        = string
}

variable "customer_tag_value" {
  description = "The value for the customer tag for resources"
  type        = string
}

variable "department_tag_value" {
  description = "The value for the department tag for resources"
  type        = string
}

variable "disk_size" {
  description = "The size of disk for the VM (in GB)"
  type        = string
  default     = "100"

}

variable "disk_type" {
  description = "The type of disk for the VM"
  type        = string
  default     = "Premium_LRS"
}

variable "owner_tag_value" {
  description = "The value for the owner tag for resources"
  type        = string
}

variable "resource_group_region" {
  description = "Azure region for YBA"
  type        = string
  default     = "eastus"
}

variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "sales_region_tag_value" {
  description = "The value for the sales region tag for resources"
  type        = string
}

variable "source_image_offer" {
  description = "The offer for the source image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "source_image_publisher" {
  description = "The publisher of the source image"
  type        = string
  default     = "Canonical"
}

variable "source_image_sku" {
  description = "The SKU for the source image"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "source_image_version" {
  description = "The version of the source image"
  type        = string
  default     = "latest"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the YBA subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subscription_id" {
  description = "The subscription ID to use"
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

variable "virtual_machine_size" {
  description = "The size of the VM for YBA"
  type        = string
  default     = "Standard_D8s_v3"
}

variable "virtual_machine_zone" {
  description = "The zone to create the VM in"
  type        = string
  default     = "1"
}

variable "vnet_cidr_block" {
  description = "CIDR block for the YBA vnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "yba_nsg_source_cidr" {
  description = "Source CIDR block of external access for the YBA network security group"
  type        = string
}