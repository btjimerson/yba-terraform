output "yba_api_token" {
  description = "The API token for the YBA admin user"
  value       = yba_customer_resource.yba_admin.api_token
  sensitive   = true
}
output "yba_hostname" {
  description = "The hostname of the YBA instance"
  value       = google_compute_instance.yba_instance.network_interface.0.access_config.0.nat_ip
}
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
output "yba_subnet" {
  description = "The subnet created for YBA"
  value       = google_compute_subnetwork.yba_subnet.name
}
output "provider_subnet" {
  description = "The subnet created for the provider"
  value       = google_compute_subnetwork.universe_subnet.name
}

