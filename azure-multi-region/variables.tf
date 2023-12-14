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

variable "resource_group" {
  description = "The resource group for Yugabyte"
  type = object({
    name   = string
    region = string
  })
}

variable "resource_prefix" {
  description = "Prefix to use for all resource names."
  type        = string
}

variable "sales_region_tag_value" {
  description = "The value for the sales region tag for resources"
  type        = string
}

variable "ssh_private_key_path" {
  description = "The path to your private SSH key"
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
  description = "The tenant ID from Microsoft Entra ID"
  type        = string
}

variable "universe_vnets" {
  description = "A map of vnets to create (1 per region) for universes"
  type = list(object({
    name            = string
    region          = string
    vnet_cidr_block = string
    subnets         = list(string)
  }))
}

variable "yba_admin_name" {
  description = "The username for the YBA admin"
  type        = string
}

variable "yba_admin_email" {
  description = "The email address for the YBA admin"
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

variable "yba_license_file" {
  description = "The path to the license file for YBA"
  type        = string
}

variable "yba_nsg_source_cidr" {
  description = "The source CIDR block of external access for the YBA network security group. This is probably your IP address."
  type        = string
}

variable "yba_vnet" {
  description = "The vnet for YBA"
  type = object({
    name            = string
    region          = string
    vnet_cidr_block = string
    subnets         = list(string)
  })
}

variable "yba_settings_file" {
  description = "The path to the settings file for YBA"
  type        = string
  default     = ""
}

variable "yba_source_image_offer" {
  description = "The offer for the YBA VM source image"
  type        = string
}

variable "yba_source_image_publisher" {
  description = "The publisher of the YBA VM source image"
  type        = string
}

variable "yba_source_image_sku" {
  description = "The SKU for the YBA VM source image"
  type        = string
}

variable "yba_source_image_version" {
  description = "The version of the YBA VM source image"
  type        = string
  default     = "latest"
}

variable "yba_version" {
  description = "The version of YBA to install (including build number)"
  type        = string
}

variable "yba_virtual_machine_size" {
  description = "The size of the VM for YBA."
  type        = string
  default     = "Standard_D8s_v3"
}
