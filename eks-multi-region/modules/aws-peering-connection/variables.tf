variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}
variable "local_region" {
  description = "The region of the local VPC"
  type        = string
}
variable "peer_region" {
  description = "The region of the peer VPC"
  type        = string
}
variable "local_vpc_id" {
  description = "The ID of the requester VPC"
  type        = string
}
variable "local_vpc_cidr_block" {
  description = "The CIDR block of the main VPC"
  type        = string
}
variable "local_route_table_id" {
  description = "The ID of the public route table for the main VPC"
  type        = string
}
variable "peer_vpc_id" {
  description = "The ID of the peer VPC"
  type        = string
}
variable "peer_vpc_cidr_block" {
  description = "The CIDR block of the peer VPC"
  type        = string
}
variable "peer_route_table_id" {
  description = "The ID of the public route table for the peer VPC"
  type        = string
}
