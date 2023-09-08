output "vpc_id" {
  description = "The ID of the VPC created"
  value       = aws_vpc.yb_vpc.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.yb_public_subnet.id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.yb_public_rt.id
}

output "security_group_id" {
  description = "The ID of the Yugabyte security group"
  value       = aws_security_group.yb_sg.id
}