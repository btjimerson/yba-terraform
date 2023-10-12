output "public_subnets" {
  description = "The public subnets created"
  value       = [for subnet in aws_subnet.yb_public_subnets : "${subnet.availability_zone}: ${subnet.id}"]
}
output "region_name" {
  description = "The name of the VPC region"
  value       = var.region
}
output "universe_security_group_id" {
  description = "The ID of the universe security group"
  value       = aws_security_group.universe_sg.id
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.yb_vpc.id
}
output "yba_api_token" {
  description = "The API token for the admin user"
  value       = yba_customer_resource.yba_admin.api_token
  sensitive   = true
}
output "yba_ip_address" {
  description = "The IP address of YBA"
  value       = aws_instance.yba.public_ip
}
output "yba_url" {
  description = "The URL for the YBA UI"
  value       = "https://${aws_instance.yba.public_ip}"
}
