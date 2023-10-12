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
variable "private_subnets" {
  description = "The private subnets to create"
  type = map(object({
    cidr_block = string
    zone       = string
  }))
}
variable "public_subnets" {
  description = "The public subnets to create"
  type = map(object({
    cidr_block = string
    zone       = string
  }))
}
variable "region" {
  description = "AWS Region for to install in"
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
variable "security_groups_external_source_cidr" {
  description = "Source CIDR block of external access for the security groups"
  type        = string
}
variable "ssh_private_key_path" {
  description = "The path to your private SSH key"
  type        = string
}
variable "ssh_user" {
  description = "The SSH username."
  type        = string
}
variable "task_tag_value" {
  description = "The value for the task tag for resources"
  type        = string
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "yba_admin_email" {
  description = "The email address for the admin user (used to log in to YBA)"
  type        = string
}
variable "yba_admin_name" {
  description = "The name of the admin user for YBA"
  type        = string
}
variable "yba_ami_id" {
  description = "The ID for the YBA AMI"
  type        = string
}
variable "yba_instance_type" {
  description = "The instance type to use for YBA"
  type        = string
}
variable "yba_instance_volume_size" {
  description = "The size of the YBA EC2 instance's root disk, in GB"
  type        = number
}
variable "yba_instance_volume_type" {
  description = "The type of the YBA EC2 instance's root disk"
  type        = string
  default     = "gp2"
}
variable "yba_license_file" {
  description = "The path to the license file for YBA"
  type        = string
}
variable "yba_keypair_name" {
  description = "Keypair name for the YBA EC2 instance.  This keypair needs to be created in the YBA region; it is used for SSH access to the YBA instance."
  type        = string
}
variable "yba_settings_file" {
  description = "The path to the settings file for YBA"
  type        = string
  default     = ""
}
variable "yba_version" {
  description = "The version of YBA to install (including build number)"
  type        = string
}
