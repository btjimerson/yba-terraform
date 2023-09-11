output "replicated_url" {
  description = "The URL for the Replicated UI"
  value = "http://${azurerm_public_ip.yba_public_ip.ip_address}:8800"
}

output "yba_ip_address" {
  description = "The public IP address for YBA"
  value       = azurerm_public_ip.yba_public_ip.ip_address
}