output "cluster_1_ca_cert" {
  description = "The CA cert for the cloud cluster"
  value       = data.external.cluster_1_ca_cert.result.content
}
output "cluster_1_ca_key" {
  description = "The CA key for the cloud cluster"
  value       = data.external.cluster_1_ca_key.result.content
}
output "cluster_1_root_cert" {
  description = "The root cert for the cloud cluster"
  value       = data.external.cluster_1_root_cert.result.content
}
output "cluster_1_cert_chain" {
  description = "The CA cert for the cloud cluster"
  value       = data.external.cluster_1_cert_chain.result.content
}
output "cluster_2_ca_cert" {
  description = "The CA cert for the on-prem cluster"
  value       = data.external.cluster_2_ca_cert.result.content
}
output "cluster_2_ca_key" {
  description = "The CA key for the on-prem cluster"
  value       = data.external.cluster_2_ca_key.result.content
}
output "cluster_2_root_cert" {
  description = "The root cert for the on-prem cluster"
  value       = data.external.cluster_2_root_cert.result.content
}
output "cluster_2_cert_chain" {
  description = "The CA cert for the on-prem cluster"
  value       = data.external.cluster_2_cert_chain.result.content
}
