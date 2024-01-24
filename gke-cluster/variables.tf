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
variable "project_id" {
  description = "The project ID"
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
variable "subnet_cidr" {
  description = "The CIDR range for the new subnet"
  type        = string
  default     = "10.1.0.0/24"
}
variable "node_pool_size" {
  description = "The number of nodes in the default node pool (per zone)"
  type        = number
  default     = 1
}
variable "node_pool_machine_type" {
  description = "The machine type to use for the default node pool"
  type        = string
  default     = "c2-standard-16"
}
variable "node_pool_disk_type" {
  description = "The disk type to use for the node pool's machine disk (one of pd-standard | pd-balanced | pd-ssd)"
  type        = string
  default     = "pd-standard"
  validation {
    condition     = contains(["pd-standard", "pd-balanced", "pd-ssd"], var.node_pool_disk_type)
    error_message = "Must be one of [pd-standard pd-balanced pd-ssd]"
  }
}
variable "node_pool_disk_size" {
  description = "The size in GB for the node pool's machine disk"
  type        = number
}
variable "yba_namespace" {
  description = "The name of the namespace for YBA"
  type        = string
  default     = "yugabyte"
}
variable "yba_version" {
  description = "The version of YBA to install"
  type        = string
}
variable "yba_sa" {
  description = "The name of the YBA service account"
  type        = string
  default     = "yba-sa"
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
