output "vpc_id" {
  description = "The ID of the VPC created"
  value       = aws_vpc.yb_vpc.id
}

output "public_subnet_1_id" {
  description = "The ID of the 1st public subnet"
  value       = aws_subnet.yb_public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "The ID of the 2nd public subnet"
  value       = aws_subnet.yb_public_subnet_2.id
}

output "public_subnet_3_id" {
  description = "The ID of the 3rd public subnet"
  value       = aws_subnet.yb_public_subnet_3.id
}

output "public_route_table_1_id" {
  description = "The ID of the 1st public route table"
  value       = aws_route_table.yb_public_rt_1.id
}

output "public_route_table_2_id" {
  description = "The ID of the 2nd public route table"
  value       = aws_route_table.yb_public_rt_2.id
}

output "public_route_table_3_id" {
  description = "The ID of the 3rd public route table"
  value       = aws_route_table.yb_public_rt_3.id
}

output "security_group_id" {
  description = "The ID of the Yugabyte security group"
  value       = aws_security_group.yb_sg.id
}