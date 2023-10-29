variable "kubernetes_version" {
  description = "The version of Kubernetes version"
  type        = string
}
variable "node_machine_type" {
  description = "The machine type to use for the nodes"
  type        = string
}
variable "number_of_nodes" {
  description = "The initial number of nodes in the node pool (this is per availability zone)"
  type        = number
}
variable "region" {
  description = "The region that the GKE cluster resides in"
  type        = string
}
variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}
variable "subnet_self_link" {
  description = "The self link to the subnet to install GKE cluster in"
  type        = string
}
variable "vpc_self_link" {
  description = "The self link to the VPC to install GKE cluster in"
  type        = string
}

