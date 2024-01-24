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
variable "enable_yba_tls" {
  description = "Whether or not to enable TLS for YBA"
  type        = bool
}
variable "gke_cluster_name" {
  description = "The name(s) of the clusters to be deployed"
  type        = string
}
variable "gcp_region" {
  description = "The GCP Region"
  type        = string
}
variable "gcp_project_id" {
  description = "The GCP Project ID"
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
