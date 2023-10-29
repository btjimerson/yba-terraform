variable "customer_tag_value" {
  description = "The value for the customer tag for resources"
  type        = string
}
variable "department_tag_value" {
  description = "The value for the department tag for resources"
  type        = string
}
variable "eks_kubernetes_version" {
  description = "The Kubernetes version to use"
  type        = string
  default     = "1.28"
}
variable "node_group_disk_size" {
  description = "The disk size in GB for worker nodes"
  type        = number
  default     = 50
}
variable "node_group_instance_type" {
  description = "The instance type for the worker nodes"
  type        = string
}
variable "number_of_subnets" {
  description = "The number of subnets to create"
  type        = number
  default     = 3
}
variable "owner_tag_value" {
  description = "The value for the owner tag for resources"
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
variable "task_tag_value" {
  description = "The value for the task tag for resources"
  type        = string
}
variable "universe_management_namespace" {
  description = "The namespace for the universement management sa and role"
  type        = string
}
variable "universe_management_sa" {
  description = "The name of the universe management service account"
  type        = string
}
variable "universe_management_cluster_role" {
  description = "The name of the universe management cluster role"
  type        = string
}
variable "universe_management_cluster_role_binding" {
  description = "The name of the universe management cluster role binding"
  type        = string
}
variable "vpc_1" {
  description = "The first vpc to create"
  type = object({
    region     = string
    cidr_block = string
  })
}
variable "vpc_2" {
  description = "The second vpc to create"
  type = object({
    region     = string
    cidr_block = string
  })
}
variable "yba_namespace" {
  description = "The name of the namespace for YBA"
  type        = string
}
variable "yba_pull_secret" {
  description = "The pull secret for YBA"
  type        = string
}
variable "yba_role" {
  description = "The name of the YBA role"
  type        = string
}
variable "yba_role_binding" {
  description = "The name of the YBA role binding"
  type        = string
}
variable "yba_sa" {
  description = "The name of the YBA service account"
  type        = string
}
variable "yba_version" {
  description = "The version of YBA to install"
  type        = string
}
