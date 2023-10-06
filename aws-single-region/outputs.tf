output "yba_replicated_url" {
  description = "Replicated URL"
  value       = "http://${aws_instance.yba.public_ip}:8800"
}

output "region_name" {
  description = "The name of the VPC region"
  value       = var.region
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.yb_vpc.id
}

output "universe_security_group_id" {
  description = "The ID of the universe security group"
  value       = aws_security_group.universe_sg.id
}

output "public_subnets" {
  description = "The public subnets created"
  value       = [for subnet in aws_subnet.yb_public_subnets : "${subnet.availability_zone}: ${subnet.id}"]
}
