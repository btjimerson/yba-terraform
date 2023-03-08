output "yba_replicated_url" {
  description = "Replicated URL"
  value       = module.yb_platform.yba_replicated_url
}

output "region_name" {
  description = "The name of the VPC region"
  value       = var.yb_region
}

output "region_vpc_id" {
  description = "The ID of the VPC"
  value       = module.yb_vpc_region.vpc_id
}

output "region_security_group_id" {
  description = "The ID of the Yugabyte security group"
  value       = module.yb_vpc_region.security_group_id
}

output "region_public_zone_1" {
  description = "The availability zone of the 1st public subnet"
  value       = var.yb_public_subnet_1_zone
}

output "region_public_subnet_1_id" {
  description = "The ID of the 1st public subnet"
  value       = module.yb_vpc_region.public_subnet_1_id
}

output "region_public_zone_2" {
  description = "The availability zone of the 2nd public subnet"
  value       = var.yb_public_subnet_2_zone
}

output "region_public_subnet_2_id" {
  description = "The ID of the 2nd public subnet"
  value       = module.yb_vpc_region.public_subnet_2_id
}

output "region_public_zone_3" {
  description = "The availability zone of the 3rd public subnet"
  value       = var.yb_public_subnet_3_zone
}

output "region_public_subnet_3_id" {
  description = "The ID of the 3rd public subnet"
  value       = module.yb_vpc_region.public_subnet_3_id
}
