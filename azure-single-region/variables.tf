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
}

variable "disk_type" {
  description = "The type of disk for the VM"
  type        = string
}

variable "nsg_source_cidr" {
  description = "Source CIDR block of external access for the network security group"
  type        = string
}

variable "owner_tag_value" {
  description = "The value for the owner tag for resources"
  type        = string
}

variable "resource_group_region" {
  description = "Azure region for YBA"
  type        = string
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
}

variable "source_image_publisher" {
  description = "The publisher of the source image"
  type        = string
}

variable "source_image_sku" {
  description = "The SKU for the source image"
  type        = string
}

variable "source_image_version" {
  description = "The version of the source image"
  type        = string
}

variable "subnet_cidr_block" {
  description = "CIDR block for the YBA subnet"
  type        = string
}

variable "task_tag_value" {
  description = "The value for the task tag for resources"
  type        = string
}

variable "virtual_machine_size" {
  description = "The size of the VM for YBA"
  type        = string
}

variable "virtual_machine_zone" {
  description = "The zone to create the VM in"
  type        = string
}

variable "vnet_cidr_block" {
  description = "CIDR block for the YBA vnet"
  type        = string
}