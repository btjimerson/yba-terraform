output "cluster_secret" {
  description = "The remote secret for Istio cluster"
  value       = data.external.cluster_secret.result.content
}
