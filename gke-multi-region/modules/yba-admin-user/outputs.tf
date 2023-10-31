output "yba_api_token" {
  description = "The API token for the YBA superadmin"
  value       = yba_customer_resource.yba_admin.api_token
}
