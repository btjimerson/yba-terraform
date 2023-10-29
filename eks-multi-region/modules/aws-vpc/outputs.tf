output "route_table_id" {
  description = "The ID of the public route table created"
  value       = aws_route_table.public_route_table.id
}
output "subnet_ids" {
  description = "The IDs of the subnets created"
  value       = [for subnet in aws_subnet.subnets : "${subnet.id}"]
}
output "vpc_id" {
  description = "The ID of the VPC created"
  value       = aws_vpc.vpc.id
}
