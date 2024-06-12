# Providers
terraform {
  backend "gcs" {
    bucket = "bjimerson-tf-backend"
    prefix = "bjimerson-gcp-yba-universe"
  }
  required_providers {
    yba = {
      source  = "yugabyte/yba"
      version = "0.1.11"
    }
  }
}

# Remote state from gcp-single-region
data "terraform_remote_state" "gcp_single_region" {
  backend = "gcs"
  config = {
    bucket = "bjimerson-tf-backend"
    prefix = "bjimerson-gcp-single-region"
  }
}

# Provider configuration
provider "yba" {
  api_token    = data.terraform_remote_state.gcp_single_region.outputs.yba_api_token
  enable_https = var.yba_use_tls
  host         = var.yba_hostname
}

# Create cloud provider
resource "yba_cloud_provider" "gcp" {

  code        = "gcp"
  dest_vpc_id = data.terraform_remote_state.gcp_single_region.outputs.provider_network_name
  name        = var.cloud_provider_name
  gcp_config_settings {
    network      = data.terraform_remote_state.gcp_single_region.outputs.provider_network_name
    use_host_vpc = true
    application_credentials = {
      type           = "service_account"
      private_key_id = var.application_credentials.private_key_id
      private_key    = var.application_credentials.private_key
      client_email   = var.application_credentials.client_email
      client_id      = var.application_credentials.client_id
    }
    project_id = var.project_id
  }
  regions {
    code = data.terraform_remote_state.gcp_single_region.outputs.provider_region
    name = data.terraform_remote_state.gcp_single_region.outputs.provider_region
    zones {
      subnet = data.terraform_remote_state.gcp_single_region.outputs.provider_subnet
    }
  }
  ssh_port        = 22
  air_gap_install = false
}

# Get cloud provider access key
data "yba_provider_key" "cloud_key" {
  provider_id = yba_cloud_provider.gcp.id
}

# Get default software version
data "yba_release_version" "release_version" {
}

# Create a universe
resource "yba_universe" "gcp_universe" {
  clusters {
    cloud_list {
      code = "gcp"
      region_list {
        az_list {
          name      = data.terraform_remote_state.gcp_single_region.outputs.provider_region
          num_nodes = var.universe_number_of_nodes
          subnet    = data.terraform_remote_state.gcp_single_region.outputs.provider_region
        }
        code = data.terraform_remote_state.gcp_single_region.outputs.provider_region
        uuid = yba_cloud_provider.gcp.regions[0].uuid
      }
      uuid = yba_cloud_provider.gcp.id
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
      enable_ycql   = var.universe_enable_ycql
      enable_ysql   = var.universe_enable_ysql
      instance_type = var.universe_instance_type
      instance_tags = {
        "yb_dept"        = var.department_tag_value
        "yb_task"        = var.task_tag_value
        "yb_owner"       = var.owner_tag_value
        "yb_customer"    = var.customer_tag_value
        "yb_salesregion" = var.sales_region_tag_value
      }
      num_nodes           = var.universe_number_of_nodes
      provider            = yba_cloud_provider.gcp.id
      provider_type       = yba_cloud_provider.gcp.code
      region_list         = yba_cloud_provider.gcp.regions[*].uuid
      replication_factor  = var.universe_replication_factor
      universe_name       = var.universe_name
      yb_software_version = data.yba_release_version.release_version.id
      ycql_password       = var.universe_ycql_password
      ysql_password       = var.universe_ysql_password
    }
  }
}

