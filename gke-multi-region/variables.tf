variable "customer_tag_value" {
  description = "The value for the customer tag for resources"
  type        = string
}
variable "department_tag_value" {
  description = "The value for the department tag for resources"
  type        = string
}
variable "istio_mesh_name" {
  description = "The mesh name for Istio"
  type        = string
}
variable "istio_namespace" {
  description = "The root namespace for Istio"
  type        = string
}
variable "gcp_project_id" {
  description = "The GCP project ID to use"
  type        = string
}
variable "istio_version" {
  description = "The version of Istio to install"
  type        = string
}
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
variable "number_of_subnets" {
  description = "The number of subnets to create"
  type        = number
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
variable "subnets" {
  description = "A list of subnets to create"
  type = list(object({
    cidr_range = string
    region     = string
  }))
}
variable "yba_admin_email" {
  description = "The email address for the superadmin user"
  type        = string
}
variable "yba_admin_name" {
  description = "The name of the superadmin user"
  type        = string
}
variable "yba_namespace" {
  description = "The name of the namespace for YBA"
  type        = string
}
variable "yba_pull_secret" {
  description = "The pull secret for YBA (base 64 encoded)"
  type        = string
}
variable "yba_version" {
  description = "The version of YBA to install"
  type        = string
}
