variable "istio_namespace" {
  description = "The name of the namespace for Istio"
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
variable "yba_namespace" {
  description = "The name of the namespace for YBA"
  type        = string
}
