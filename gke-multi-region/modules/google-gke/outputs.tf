output "cluster_ca_certificate" {
  description = "The CA certificate for connecting to the GKE cluster"
  value       = google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
}
output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.gke_cluster.endpoint
}
output "cluster_name" {
  description = "The name of the cluster created"
  value       = local.cluster_name
}
output "cluster_token" {
  description = "A token to use for the Kubernetes provider"
  value       = data.google_client_config.provider.access_token
}


