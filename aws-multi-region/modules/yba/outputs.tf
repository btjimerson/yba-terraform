output "yba_ip_address" {
  description = "The IP address of YBA"
  value       = aws_instance.yba.public_ip
}
output "yba_url" {
  description = "The URL for the YBA UI"
  value       = "https://${aws_instance.yba.public_ip}"
}

output "vpc_id" {
  description = "The ID of the Yugabyte Platform VPC"
  value       = aws_vpc.yba_vpc.id
}

output "public_route_table_id" {
  description = "The ID of the Yugabyte Platform public route table"
  value       = aws_route_table.yba_public_rt.id
}
