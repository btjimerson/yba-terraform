variable "number_of_subnets" {
  description = "The number of subnets to create"
  type        = number
}
variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
