output "configure_kubectl_command" {
  description = "Run this command to configure kubectl to use this cluster"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.cluster.name} --region ${var.region} --project ${var.project_id}"
}

output "kubeconfig_raw" {
  description = "The raw kubeconfig text. This is considered sensitive; it can be viewed with 'terraform output kubeconfig_raw' "
  value       = module.gke_auth.kubeconfig_raw
  sensitive   = true
}