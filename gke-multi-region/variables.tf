variable "customer_tag_value" {
  description = "The value for the customer tag for resources"
  type        = string
}
variable "department_tag_value" {
  description = "The value for the department tag for resources"
  type        = string
}
variable "enable_yba_tls" {
  description = "Whether or not to enable TLS for YBA"
  type        = bool
  default     = true
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
variable "gcp_project_id" {
  description = "The GCP project ID to use"
  type        = string
}
variable "istio_namespace" {
  description = "The name of the namespace for Istio"
  type        = string
  default     = "istio-system"
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
variable "universe_management_sa" {
  description = "The name of the universe management service account"
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
variable "yba_namespace" {
  description = "The name of the namespace for YBA"
  type        = string
}
variable "yba_version" {
  description = "The version of YBA to install"
  type        = string
}
