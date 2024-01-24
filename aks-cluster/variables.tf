variable "admin_username" {
  description = "The username for the Linux admin"
  type        = string
}
variable "customer_tag_value" {
  description = "The value for the customer tag for resources"
  type        = string
}
variable "department_tag_value" {
  description = "The value for the department tag for resources"
  type        = string
}
variable "image_registry_email" {
  description = "The email of the server for the Docker image registry"
  type        = string
}
variable "image_registry_password" {
  description = "The password for the Docker image registry"
  type        = string
}
variable "image_registry_server" {
  description = "The name of the server for the Docker image registry"
  type        = string
}
variable "image_registry_username" {
  description = "The username for the Docker image registry"
  type        = string
}
variable "node_count" {
  description = "The number of nodes in the AKS node pool"
  type        = number
}
variable "node_size" {
  description = "The machine size for the nodes in the AKS node pool"
  type        = string
}
variable "owner_tag_value" {
  description = "The value for the owner tag for resources"
  type        = string
}
variable "region" {
  description = "The region to create the cluster in"
  type        = string
}
variable "resource_prefix" {
  description = "A prefix added to all created resources"
  type        = string
}
variable "sales_region_tag_value" {
  description = "The value for the sales region tag for resources"
  type        = string
}
variable "subscription_id" {
  description = "The subscription ID to use for Azure resources"
  type        = string
}
variable "task_tag_value" {
  description = "The value for the task tag for resources"
  type        = string
}
variable "yba_namespace" {
  description = "The name of the namespace for YBA"
  type        = string
  default     = "yugabyte"
}
variable "yba_role" {
  description = "The name of the YBA role"
  type        = string
  default     = "yba-role"
}
variable "yba_role_binding" {
  description = "The name of the YBA role binding"
  type        = string
  default     = "yba-role-binding"
}
variable "yba_sa" {
  description = "The name of the YBA service account"
  type        = string
  default     = "yba-sa"
}
variable "yba_version" {
  description = "The version of YBA to install"
  type        = string
}
variable "yba_universe_management_cluster_role" {
  description = "The name of the universe management cluster role"
  type        = string
  default     = "yugabyte-platform-global-admin"
}
variable "yba_universe_management_cluster_role_binding" {
  description = "The name of the universe management cluster role binding"
  type        = string
  default     = "yugabyte-platform-global-admin"
}
variable "yba_universe_management_namespace" {
  description = "The namespace for the universement management sa and role"
  type        = string
  default     = "kube-system"
}
variable "yba_universe_management_sa" {
  description = "The name of the universe management service account"
  type        = string
  default     = "yugabyte-platform-universe-management"
}
