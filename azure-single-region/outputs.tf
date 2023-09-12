output "provider_application_client_id" {
  description = "The application client ID for the Azure cloud provider"
  value       = azuread_application.yba_application.application_id
}

output "provider_application_client_secret" {
  description = "The application client secret for the Azure cloud provider"
  value       = azuread_application_password.yba_application_password.value
  sensitive   = true
}

output "provider_region_subnet_names" {
  description = "The subnet name to use for the Azure cloud provider's region's 1st zone"
  value       = azurerm_subnet.yba_subnet.name
}

output "provider_region_virtual_network_name" {
  description = "The virtual network name to use for the Azure cloud provider"
  value = azurerm_virtual_network.yba_vnet.name
}

output "provider_resource_group" {
  description = "The resource group for the Azure cloud provider"
  value       = azurerm_resource_group.yba_resource_group.name
}

output "provider_subscription_id" {
  description = "The subscription id for the Azure cloud provider"
  value       = var.subscription_id
}

output "provider_tenant_id" {
  description = "The tenant id for the Azure cloud provider"
  value       = var.tenant_id
}

output "replicated_url" {
  description = "The URL for the Replicated UI"
  value       = "http://${azurerm_public_ip.yba_public_ip.ip_address}:8800"
}

output "yba_ip_address" {
  description = "The public IP address for YBA"
  value       = azurerm_public_ip.yba_public_ip.ip_address
}
