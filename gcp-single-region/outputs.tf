output "yba_url" {
  description = "The URL for YBA."
  value       = "https://${google_compute_instance.yba_instance.network_interface.0.access_config.0.nat_ip}"
}
output "provider_network_name" {
  description = "The name of the VPC network created."
  value       = google_compute_network.vpc.name
}
output "provider_region" {
  description = "The region to use for subnets."
  value       = var.region
}
output "provider_subnets" {
  description = "The subnets created for the provider"
  value       = [for subnet in google_compute_subnetwork.universe_subnets : subnet.name]

}

