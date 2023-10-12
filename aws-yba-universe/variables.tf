variable "cloud_provider_name" {
  description = "The name for the cloud provider"
  type        = string
}
variable "cloud_provider_region_code" {
  description = "The code of the AWS region for the provider"
  type        = string
}
variable "cloud_provider_region_latitude" {
  description = "The latitude of the provider's region"
  type        = number
}
variable "cloud_provider_region_longitude" {
  description = "The longitude of the provider's region"
  type        = number
}
variable "cloud_provider_region_security_group_id" {
  description = "The security group ID for the region"
  type        = string
}
variable "cloud_provider_region_vpc_id" {
  description = "The VPC ID for the region"
  type        = string
}
variable "cloud_provider_region_zones" {
  description = "The zones to define for the region"
  type = map(object({
    code      = string
    subnet_id = string
  }))
}
variable "device_info_disk_iops" {
  description = "The provisioned disk IOPS"
  type        = number
  default     = 3000
}
variable "device_info_number_of_volumes" {
  description = "The number of volumes for universe devices"
  type        = number
  default     = 1
}
variable "device_info_storage_type" {
  description = "The storage type for universe devices"
  type        = string
}
variable "device_info_throughput" {
  description = "The provisioned disk throughput"
  type        = number
  default     = 125
}
variable "device_info_volume_size" {
  description = "The size of the volumes for universe devices"
  type        = number
}
variable "universe_assign_public_ip" {
  description = "Should we assign public IPs to the nodes?"
  type        = bool
  default     = false
}
variable "universe_enable_ycql" {
  description = "Should YCQL be enabled for the universe?"
  type        = bool
  default     = true
}
variable "universe_enable_ysql" {
  description = "Should YSQL be enabled for the universe?"
  type        = bool
  default     = true
}
variable "universe_instance_type" {
  description = "The instance type to use for universe VMs"
  type        = string
}
variable "universe_name" {
  description = "The name for the universe"
  type        = string
}
variable "universe_number_of_nodes" {
  description = "The number of nodes for the universe"
  type        = number
  default     = 3
}
variable "universe_replication_factor" {
  description = "The replication factor for the universe"
  type        = number
  default     = 3
}
variable "universe_ycql_password" {
  description = "The password for YCQL"
  type        = string
  sensitive   = true
}
variable "universe_ysql_password" {
  description = "The password for YSQL"
  type        = string
  sensitive   = true
}
variable "yba_api_token" {
  description = "The API token to use for YBA authentication"
  type        = string
  sensitive   = true
}
variable "yba_host" {
  description = "The hostname or IP address for YBA"
  type        = string
}
variable "yba_use_tls" {
  description = "Should we use tls (https)?"
  type        = bool
  default     = true

}
