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
variable "task_tag_value" {
  description = "The value for the task tag for resources"
  type        = string
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "yba_ami_filter" {
  description = "A string to filter for the Yugabyte Platform AMI"
  type        = string
}
variable "yba_ami_owner" {
  description = "The owner of the AMI to use for Yugabyte Platform"
  type        = string
}
variable "yba_instance_type" {
  description = "The instance type to use for Yugabyte Platform"
  type        = string
}
variable "yba_instance_volume_size" {
  description = "The size of the Yugabyte Platform EC2 instance's root disk, in GB"
  type        = number
}
variable "yba_instance_volume_type" {
  description = "The type of the Yugabyte Platform EC2 instance's root disk"
  type        = string
  default     = "gp2"
}
variable "yba_keypair_name" {
  description = "Keypair name for the Yugabyte Platform EC2 instance.  This keypair needs to be created in the Yugabyte Platform region; it is used for SSH access to the Yugabyte Platform instance."
  type        = string
}
