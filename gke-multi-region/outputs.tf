output "gke_cluster_endpoint" {
  description = "The IP address of the GKE cluster"
  value       = module.gke_clusters[0].cluster_endpoint
}
output "yba_hostname" {
  description = "The hostname or IP address of YBA"
  value       = "https://${module.yba.yba_hostname}"
}
output "yba_api_token" {
  description = "The API token for the YBA superadmin"
  sensitive   = true
  value       = module.yba_admin_user.yba_api_token
}

