variable "eks_kubernetes_version" {
  description = "The Kubernetes version to use"
  type        = string
}
variable "node_group_disk_size" {
  description = "The disk size in GB for worker nodes"
  type        = number
}
variable "node_group_instance_type" {
  description = "The instance type for the worker nodes"
  type        = string
}
variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}
variable "eks_subnet_ids" {
  description = "A list of subnet ids to install the EKS cluster in"
  type        = list(string)
}
