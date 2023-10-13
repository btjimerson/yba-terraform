<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_yba"></a> [yba](#requirement\_yba) | 0.1.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yba"></a> [yba](#provider\_yba) | 0.1.8 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yba_cloud_provider.aws_cloud_provider](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/resources/cloud_provider) | resource |
| [yba_universe.aws_universe](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/resources/universe) | resource |
| [yba_provider_key.cloud_key](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/data-sources/provider_key) | data source |
| [yba_release_version.release_version](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/data-sources/release_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider_name"></a> [cloud\_provider\_name](#input\_cloud\_provider\_name) | The name for the cloud provider | `string` | n/a | yes |
| <a name="input_cloud_provider_region_code"></a> [cloud\_provider\_region\_code](#input\_cloud\_provider\_region\_code) | The code of the AWS region for the provider | `string` | n/a | yes |
| <a name="input_cloud_provider_region_latitude"></a> [cloud\_provider\_region\_latitude](#input\_cloud\_provider\_region\_latitude) | The latitude of the provider's region | `number` | n/a | yes |
| <a name="input_cloud_provider_region_longitude"></a> [cloud\_provider\_region\_longitude](#input\_cloud\_provider\_region\_longitude) | The longitude of the provider's region | `number` | n/a | yes |
| <a name="input_cloud_provider_region_security_group_id"></a> [cloud\_provider\_region\_security\_group\_id](#input\_cloud\_provider\_region\_security\_group\_id) | The security group ID for the region | `string` | n/a | yes |
| <a name="input_cloud_provider_region_vpc_id"></a> [cloud\_provider\_region\_vpc\_id](#input\_cloud\_provider\_region\_vpc\_id) | The VPC ID for the region | `string` | n/a | yes |
| <a name="input_cloud_provider_region_zones"></a> [cloud\_provider\_region\_zones](#input\_cloud\_provider\_region\_zones) | The zones to define for the region | <pre>map(object({<br>    code      = string<br>    subnet_id = string<br>  }))</pre> | n/a | yes |
| <a name="input_device_info_disk_iops"></a> [device\_info\_disk\_iops](#input\_device\_info\_disk\_iops) | The provisioned disk IOPS | `number` | `3000` | no |
| <a name="input_device_info_number_of_volumes"></a> [device\_info\_number\_of\_volumes](#input\_device\_info\_number\_of\_volumes) | The number of volumes for universe devices | `number` | `1` | no |
| <a name="input_device_info_storage_type"></a> [device\_info\_storage\_type](#input\_device\_info\_storage\_type) | The storage type for universe devices | `string` | n/a | yes |
| <a name="input_device_info_throughput"></a> [device\_info\_throughput](#input\_device\_info\_throughput) | The provisioned disk throughput | `number` | `125` | no |
| <a name="input_device_info_volume_size"></a> [device\_info\_volume\_size](#input\_device\_info\_volume\_size) | The size of the volumes for universe devices | `number` | n/a | yes |
| <a name="input_universe_assign_public_ip"></a> [universe\_assign\_public\_ip](#input\_universe\_assign\_public\_ip) | Should we assign public IPs to the nodes? | `bool` | `false` | no |
| <a name="input_universe_enable_ycql"></a> [universe\_enable\_ycql](#input\_universe\_enable\_ycql) | Should YCQL be enabled for the universe? | `bool` | `true` | no |
| <a name="input_universe_enable_ysql"></a> [universe\_enable\_ysql](#input\_universe\_enable\_ysql) | Should YSQL be enabled for the universe? | `bool` | `true` | no |
| <a name="input_universe_instance_type"></a> [universe\_instance\_type](#input\_universe\_instance\_type) | The instance type to use for universe VMs | `string` | n/a | yes |
| <a name="input_universe_name"></a> [universe\_name](#input\_universe\_name) | The name for the universe | `string` | n/a | yes |
| <a name="input_universe_number_of_nodes"></a> [universe\_number\_of\_nodes](#input\_universe\_number\_of\_nodes) | The number of nodes for the universe | `number` | `3` | no |
| <a name="input_universe_replication_factor"></a> [universe\_replication\_factor](#input\_universe\_replication\_factor) | The replication factor for the universe | `number` | `3` | no |
| <a name="input_universe_ycql_password"></a> [universe\_ycql\_password](#input\_universe\_ycql\_password) | The password for YCQL | `string` | n/a | yes |
| <a name="input_universe_ysql_password"></a> [universe\_ysql\_password](#input\_universe\_ysql\_password) | The password for YSQL | `string` | n/a | yes |
| <a name="input_yba_api_token"></a> [yba\_api\_token](#input\_yba\_api\_token) | The API token to use for YBA authentication | `string` | n/a | yes |
| <a name="input_yba_host"></a> [yba\_host](#input\_yba\_host) | The hostname or IP address for YBA | `string` | n/a | yes |
| <a name="input_yba_use_tls"></a> [yba\_use\_tls](#input\_yba\_use\_tls) | Should we use tls (https)? | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->