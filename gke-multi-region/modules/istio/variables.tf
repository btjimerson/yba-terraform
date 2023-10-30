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
variable "istio_ca_cert" {
  description = "The CA cert for Istio"
  type        = string
}
variable "istio_ca_key" {
  description = "The CA key for Istio"
  type        = string
}
variable "istio_cluster_name" {
  description = "The cluster name for Istio"
  type        = string
}
variable "istio_cert_chain" {
  description = "The cert chain for Istio"
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
variable "istio_network_name" {
  description = "The network name for Istio"
  type        = string
}
variable "istio_root_cert" {
  description = "The root cert for Istio"
  type        = string
}
variable "istio_version" {
  description = "The version of Istio to install"
  type        = string
}
