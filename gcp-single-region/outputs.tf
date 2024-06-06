output "yba_url" {
  description = "The URL for YBA."
  value       = "https://${google_compute_instance.yba_instance.network_interface.0.access_config.0.nat_ip}"
}

