output "gke_cluster_endpoint" {
  description = "The IP address of the GKE cluster"
  value       = module.gke_clusters[0].cluster_endpoint
}
output "update_kubeconfig_commands" {
  description = "Run these commands to update your kubeconfig"
  value       = [for cluster in module.gke_clusters : "gcloud container clusters get-credentials ${cluster.cluster_name} --project ${var.gcp_project_id} --region ${cluster.cluster_region}"]
}
output "yba_hostname" {
  description = "The hostname or IP address of YBA"
  value       = var.enable_yba_tls ? "https://${module.yba.yba_hostname}" : "http://${module.yba.yba_hostname}"
}
