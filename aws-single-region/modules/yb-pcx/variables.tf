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

variable "main_region" {
  description = "AWS Region"
  type        = string
}

variable "peer_region" {
  description = "The region of the peer VPC"
  type        = string
}

variable "main_vpc_id" {
  description = "The ID of the requester VPC"
  type        = string
}

variable "main_public_subnet_cidr_block" {
  description = "The CIDR block of the main VPC's public subnet"
  type        = string
}

variable "main_public_route_table_id" {
  description = "The ID of the public route table for the main VPC"
  type        = string
}

variable "peer_vpc_id" {
  description = "The ID of the peer VPC"
  type        = string
}

variable "peer_public_subnet_1_cidr_block" {
  description = "The CIDR block of the peer VPC's 1st public subnet"
  type        = string
}

variable "peer_public_route_table_1_id" {
  description = "The ID of the 1st subnet's public route table for the peer VPC"
  type        = string
}

variable "peer_public_subnet_2_cidr_block" {
  description = "The CIDR block of the peer VPC's 2nd public subnet"
  type        = string
}

variable "peer_public_route_table_2_id" {
  description = "The ID of the 2nd subnet's public route table for the peer VPC"
  type        = string
}

variable "peer_public_subnet_3_cidr_block" {
  description = "The CIDR block of the peer VPC's 3rd public subnet"
  type        = string
}

variable "peer_public_route_table_3_id" {
  description = "The ID of the 3rd subnet's public route table for the peer VPC"
  type        = string
}