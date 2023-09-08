output "yba_replicated_url" {
  description = "Replicated URL"
  value       = "http://${aws_instance.yba.public_ip}:8800"
}

output "vpc_id" {
  description = "The ID of the Yugabyte Platform VPC"
  value       = aws_vpc.yba_vpc.id
}

output "public_route_table_id" {
  description = "The ID of the Yugabyte Platform public route table"
  value       = aws_route_table.yba_public_rt.id
}