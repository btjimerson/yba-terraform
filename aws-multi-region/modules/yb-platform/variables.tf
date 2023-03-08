variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "department_tag_value" {
  description = "The value for the department tag for resources"
  type        = string
}

variable "task_tag_value" {
  description = "The value for the task tag for resources"
  type        = string
}

variable "owner_tag_value" {
  description = "The value for the owner tag for resources"
  type        = string
}

variable "customer_tag_value" {
  description = "The value for the customer tag for resources"
  type        = string
}

variable "sales_region_tag_value" {
  description = "The value for the sales region tag for resources"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "security_groups_external_source_cidr" {
  description = "Source CIDR block of external access for the security groups"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "public_subnet_zone" {
  description = "The availability zone for the public subnet"
  type        = string
}

variable "private_subnet_zone" {
  description = "The availability zone for the private subnet"
  type        = string
}

variable "ami_filter" {
  description = "A string to filter for the Yugabyte Platform AMI"
  type        = string
}

variable "ami_owner" {
  description = "The owner of the AMI to use for Yugabyte Platform"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for Yugabyte Platform"
  type        = string
}

variable "instance_volume_size" {
  description = "The size of the Yugabyte Platform EC2 instance's root disk, in GB"
  type        = number
}

variable "instance_volume_type" {
  description = "The type of the Yugabyte Platform EC2 instance's root disk"
  type        = string
}

variable "keypair_name" {
  description = "Keypair for EC2 instance"
  type        = string
}
