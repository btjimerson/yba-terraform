# Providers
terraform {
  backend "gcs" {
    bucket = "bjimerson-tf-backend"
    prefix = "bjimerson-aws-yba-universe"
  }
  required_providers {
    yba = {
      source  = "yugabyte/yba"
      version = "0.1.8"
    }
  }
}

# Provider configuration
provider "yba" {
  api_token    = var.yba_api_token
  enable_https = var.yba_use_tls
  host         = var.yba_host
}

# Create cloud provider
resource "yba_cloud_provider" "aws_cloud_provider" {
  aws_config_settings {
    use_iam_instance_profile = true
  }
  code     = "aws"
  name     = var.cloud_provider_name
  ssh_port = 22
  regions {
    code              = var.cloud_provider_region_code
    latitude          = var.cloud_provider_region_latitude
    longitude         = var.cloud_provider_region_longitude
    name              = var.cloud_provider_region_code
    security_group_id = var.cloud_provider_region_security_group_id
    vnet_name         = var.cloud_provider_region_vpc_id
    dynamic "zones" {
      for_each = var.cloud_provider_region_zones
      iterator = zone
      content {
        code   = zone.value["code"]
        name   = zone.value["code"]
        subnet = zone.value["subnet_id"]
      }
    }
  }
}

# Get cloud provider access key
data "yba_provider_key" "cloud_key" {
  provider_id = yba_cloud_provider.aws_cloud_provider.id
}

# Get default software version
data "yba_release_version" "release_version" {
}

# Create a universe
resource "yba_universe" "aws_universe" {
  clusters {
    cloud_list {
      code = "aws"
      region_list {
        dynamic "az_list" {
          for_each = var.cloud_provider_region_zones
          iterator = zone
          content {
            name      = zone.value["code"]
            num_nodes = var.universe_number_of_nodes / length(var.cloud_provider_region_zones)
            subnet    = zone.value["subnet_id"]
          }
        }
        code = var.cloud_provider_region_code
        uuid = yba_cloud_provider.aws_cloud_provider.regions[0].uuid

      }
      uuid = yba_cloud_provider.aws_cloud_provider.id
    }
    cluster_type = "PRIMARY"
    user_intent {
      access_key_code  = data.yba_provider_key.cloud_key.id
      assign_public_ip = var.universe_assign_public_ip
      device_info {
        disk_iops    = var.device_info_disk_iops
        num_volumes  = var.device_info_number_of_volumes
        storage_type = var.device_info_storage_type
        volume_size  = var.device_info_volume_size
        throughput   = var.device_info_throughput
      }
      enable_ycql         = var.universe_enable_ycql
      enable_ysql         = var.universe_enable_ysql
      instance_type       = var.universe_instance_type
      num_nodes           = var.universe_number_of_nodes
      provider            = yba_cloud_provider.aws_cloud_provider.id
      provider_type       = yba_cloud_provider.aws_cloud_provider.code
      region_list         = yba_cloud_provider.aws_cloud_provider.regions[*].uuid
      replication_factor  = var.universe_replication_factor
      universe_name       = var.universe_name
      yb_software_version = data.yba_release_version.release_version.id
      ycql_password       = var.universe_ycql_password
      ysql_password       = var.universe_ysql_password
    }
  }
}
