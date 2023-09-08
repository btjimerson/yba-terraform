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

variable "security_groups_yba_cidr" {
  description = "Source CIDR of YugabyteDB Anywhere for the security groups"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_1_cidr_block" {
  description = "CIDR block for the 1st public subnet"
  type        = string
}

variable "public_subnet_2_cidr_block" {
  description = "CIDR block for the 2nd public subnet"
  type        = string
}

variable "public_subnet_3_cidr_block" {
  description = "CIDR block for the 3rd public subnet"
  type        = string
}

variable "private_subnet_1_cidr_block" {
  description = "CIDR block for the 1st private subnet"
  type        = string
}

variable "public_subnet_1_zone" {
  description = "The availability zone for the 1st public subnet"
  type        = string
}

variable "public_subnet_2_zone" {
  description = "The availability zone for the 2nd public subnet"
  type        = string
}

variable "public_subnet_3_zone" {
  description = "The availability zone for the 3rd public subnet"
  type        = string
}

variable "private_subnet_1_zone" {
  description = "The availability zone for the private subnet"
  type        = string
}