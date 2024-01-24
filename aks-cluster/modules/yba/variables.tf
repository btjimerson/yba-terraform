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
variable "yba_namespace" {
  description = "The name of the namespace for YBA"
  type        = string
}
variable "yba_version" {
  description = "The version of YBA to install"
  type        = string
}
variable "yba_sa" {
  description = "The name of the YBA service account"
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
variable "yba_universe_management_namespace" {
  description = "The namespace for the universement management sa and role"
  type        = string
}
variable "yba_universe_management_sa" {
  description = "The name of the universe management service account"
  type        = string
}
variable "yba_universe_management_cluster_role" {
  description = "The name of the universe management cluster role"
  type        = string
}
variable "yba_universe_management_cluster_role_binding" {
  description = "The name of the universe management cluster role binding"
  type        = string
}

