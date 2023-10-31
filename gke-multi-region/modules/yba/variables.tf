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
