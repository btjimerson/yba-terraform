output "yba_ip_address" {
  description = "The IP address of YBA"
  value       = module.yba.yba_ip_address
}
output "yba_url" {
  description = "The URL for the YBA UI"
  value       = module.yba.yba_url
}

output "region_1_name" {
  description = "The name of the first VPC region"
  value       = var.yb_region_1_region
}

output "region_1_vpc_id" {
  description = "The ID of the VPC for the first region"
  value       = module.yb_vpc_region_1.vpc_id
}

output "region_1_security_group_id" {
  description = "The ID of the Yugabyte security group in the first region"
  value       = module.yb_vpc_region_1.security_group_id
}

output "region_1_public_zone" {
  description = "The availability zone of the public subnet in the first region"
  value       = var.yb_region_1_public_subnet_zone
}

output "region_1_public_subnet_id" {
  description = "The ID of the public subnet in the first region"
  value       = module.yb_vpc_region_1.public_subnet_id
}

output "region_2_name" {
  description = "The name of the second VPC region"
  value       = var.yb_region_2_region
}

output "region_2_vpc_id" {
  description = "The ID of the VPC for the second region"
  value       = module.yb_vpc_region_2.vpc_id
}

output "region_2_security_group_id" {
  description = "The ID of the Yugabyte security group in the second region"
  value       = module.yb_vpc_region_2.security_group_id
}

output "region_2_public_zone" {
  description = "The availability zone of the public subnet in the second region"
  value       = var.yb_region_2_public_subnet_zone
}

output "region_2_public_subnet_id" {
  description = "The ID of the public subnet in the second region"
  value       = module.yb_vpc_region_2.public_subnet_id
}

output "region_3_name" {
  description = "The name of the third VPC region"
  value       = var.yb_region_3_region
}

output "region_3_vpc_id" {
  description = "The ID of the VPC for the third region"
  value       = module.yb_vpc_region_3.vpc_id
}

output "region_3_security_group_id" {
  description = "The ID of the Yugabyte security group in the third region"
  value       = module.yb_vpc_region_3.security_group_id
}

output "region_3_public_zone" {
  description = "The availability zone of the public subnet in the third region"
  value       = var.yb_region_3_public_subnet_zone
}

output "region_3_public_subnet_id" {
  description = "The ID of the public subnet in the third region"
  value       = module.yb_vpc_region_3.public_subnet_id
}

