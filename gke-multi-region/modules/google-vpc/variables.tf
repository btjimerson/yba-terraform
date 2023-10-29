variable "subnets" {
  description = "A list of subnets to create"
  type = list(object({
    region     = string
    cidr_range = string
  }))
}
variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}

