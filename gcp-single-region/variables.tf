variable "customer_tag_value" {
  description = "The value for the customer tag for resources"
  type        = string
}
variable "department_tag_value" {
  description = "The value for the department tag for resources"
  type        = string
}
variable "owner_tag_value" {
  description = "The value for the owner tag for resources"
  type        = string
}
variable "project_id" {
  description = "The project ID"
  type        = string
}
variable "region" {
  description = "The region to create the cluster in"
  type        = string
}
variable "resource_prefix" {
  description = "A prefix added to all created resources"
  type        = string
}
variable "sales_region_tag_value" {
  description = "The value for the sales region tag for resources"
  type        = string
}
variable "task_tag_value" {
  description = "The value for the task tag for resources"
  type        = string
}
variable "universe_subnet" {
  description = "Subnet to create for YB universes"
  type        = string
  default     = "10.0.2.0/24"
}
variable "yb_allowed_source_range" {
  description = "The allowed source IP range for YB resources"
  type        = string
}
variable "yba_admin_email" {
  description = "The email address for the YBA administrator"
  type        = string
}
variable "yba_admin_name" {
  description = "The username for the YBA administrator"
  type        = string
}
variable "yba_boot_disk_size" {
  description = "The size of the YBA instance's boot disk (in GB)"
  type        = number
  default     = 500
}
variable "yba_instance_image" {
  description = "The image to use for the YBA compute instance"
  type        = string
}
variable "yba_instance_type" {
  description = "The instance type to use for the YBA compute instance"
  type        = string
}
variable "yba_instance_zone" {
  description = "The zone to create the YBA compute instance in"
  type        = string
}
variable "yba_license_file" {
  description = "The path to the license file for YBA"
  type        = string
}
variable "yba_settings_file" {
  description = "The path to the settings file for YBA (leave blank to use defaults)"
  type        = string
  default     = ""
}
variable "yba_ssh_admin_username" {
  description = "The username for the SSH admin for the YBA instance"
  type        = string
}
variable "yba_ssh_private_key_path" {
  description = "The path to the private key to use for SSH access to the YBA instance"
  type        = string
}
variable "yba_subnet_cidr" {
  description = "The CIDR block for the YBA subnet"
  type        = string
  default     = "10.0.1.0/24"
}
variable "yba_version" {
  description = "The version of YBA to install"
  type        = string
}
