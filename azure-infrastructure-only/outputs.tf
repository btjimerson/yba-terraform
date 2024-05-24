output "provider_application_client_id" {
  description = "The application client ID for the Azure cloud provider."
  value       = azuread_application.yba_application.application_id
}

output "provider_application_client_secret" {
  description = "The application client secret for the Azure cloud provider."
  value       = azuread_application_password.yba_application_password.value
  sensitive   = true
}

output "provider_vnet_id" {
  description = "The ID of the created vnet for the Azure cloud provider."
  value       = azurerm_virtual_network.yb_vnet.guid
}

output "provider_region_subnet_names" {
  description = "The subnet names to use for the Azure cloud provider's region."
  value       = [for subnet in azurerm_subnet.universe_subnets : subnet.name]
}

output "provider_region_virtual_network_name" {
  description = "The virtual network name to use for the Azure cloud provider."
  value       = azurerm_virtual_network.yb_vnet.name
}

output "provider_resource_group" {
  description = "The resource group for the Azure cloud provider."
  value       = azurerm_resource_group.yb_resource_group.name
}

output "provider_subscription_id" {
  description = "The subscription id for the Azure cloud provider."
  value       = var.subscription_id
}

output "provider_tenant_id" {
  description = "The tenant id for the Azure cloud provider."
  value       = var.tenant_id
}

output "yba_url" {
  description = "The URL for YBA."
  value       = "https://${azurerm_public_ip.yba_public_ip.ip_address}"
}
