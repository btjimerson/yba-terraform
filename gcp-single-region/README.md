# YugabyteDB Anywhere GKE Configuration

## Introduction

This repository contains a Terraform configuration to create GCP infrastructure with YugabyteDB Anywhere. By default, this configuration creates:

* A VPC
* A public subnet in the VPC
* A compute instance for YBA
* YugabyteDB Anywhere

## Prerequisites

The following must be done manually prior to applying the configuration:

* Install [gcloud](https://cloud.google.com/sdk/docs/install) on your workstation
* Install the [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your workstation
* Install [terrform-docs](https://terraform-docs.io/user-guide/installation/) on your workstation
* Initialize the gcloud CLI: `gcloud init`
* Log in to GCP: `gcloud auth application-default login`

## Installation

First, create a terraform variables file. The easiest way to set the required variables is to use `terraform-docs`
```bash
terraform-docs tfvars hcl . > myvars.auto.tfvars
```
Any variables that are blank will need to be set in a `*.auto.tfvars` or `terraform.tfvars` file. Optionally, you can override variables that have a default value.


Once you have the variables defined you can apply the configuration as usual:

```
terraform init
terraform apply
```
If it is successful, you should see an output like this:

```
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

provider_network_name = "bjimerson-test-vpc"
provider_region = "us-east5"
provider_subnets = [
  "bjimerson-test-universe-subnet-1",
  "bjimerson-test-universe-subnet-2",
  "bjimerson-test-universe-subnet-3",
]
yba_url = "https://34.162.244.52"


```

To access the YBA Plaform UI, use the output value for `yba_url`. You can use the outputs that start with `provider_` to configure the GCP provider.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_yba"></a> [yba](#requirement\_yba) | 0.1.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.yb_nodes_api_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.yba_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.yba_to_yb_nodes_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.yba_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_network.vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.universe_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.yba_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_customer_tag_value"></a> [customer\_tag\_value](#input\_customer\_tag\_value) | The value for the customer tag for resources | `string` | n/a | yes |
| <a name="input_department_tag_value"></a> [department\_tag\_value](#input\_department\_tag\_value) | The value for the department tag for resources | `string` | n/a | yes |
| <a name="input_owner_tag_value"></a> [owner\_tag\_value](#input\_owner\_tag\_value) | The value for the owner tag for resources | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to create the cluster in | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | A prefix added to all created resources | `string` | n/a | yes |
| <a name="input_sales_region_tag_value"></a> [sales\_region\_tag\_value](#input\_sales\_region\_tag\_value) | The value for the sales region tag for resources | `string` | n/a | yes |
| <a name="input_task_tag_value"></a> [task\_tag\_value](#input\_task\_tag\_value) | The value for the task tag for resources | `string` | n/a | yes |
| <a name="input_universe_subnet"></a> [universe\_subnet](#input\_universe\_subnet) | Subnet to create for YB universes | `string` | `"10.0.2.0/24"` | no |
| <a name="input_yb_allowed_source_range"></a> [yb\_allowed\_source\_range](#input\_yb\_allowed\_source\_range) | The allowed source IP range for YB resources | `string` | n/a | yes |
| <a name="input_yba_admin_email"></a> [yba\_admin\_email](#input\_yba\_admin\_email) | The email address for the YBA administrator | `string` | n/a | yes |
| <a name="input_yba_admin_name"></a> [yba\_admin\_name](#input\_yba\_admin\_name) | The username for the YBA administrator | `string` | n/a | yes |
| <a name="input_yba_boot_disk_size"></a> [yba\_boot\_disk\_size](#input\_yba\_boot\_disk\_size) | The size of the YBA instance's boot disk (in GB) | `number` | `500` | no |
| <a name="input_yba_instance_image"></a> [yba\_instance\_image](#input\_yba\_instance\_image) | The image to use for the YBA compute instance | `string` | n/a | yes |
| <a name="input_yba_instance_type"></a> [yba\_instance\_type](#input\_yba\_instance\_type) | The instance type to use for the YBA compute instance | `string` | n/a | yes |
| <a name="input_yba_instance_zone"></a> [yba\_instance\_zone](#input\_yba\_instance\_zone) | The zone to create the YBA compute instance in | `string` | n/a | yes |
| <a name="input_yba_license_file"></a> [yba\_license\_file](#input\_yba\_license\_file) | The path to the license file for YBA | `string` | n/a | yes |
| <a name="input_yba_settings_file"></a> [yba\_settings\_file](#input\_yba\_settings\_file) | The path to the settings file for YBA (leave blank to use defaults) | `string` | `""` | no |
| <a name="input_yba_ssh_admin_username"></a> [yba\_ssh\_admin\_username](#input\_yba\_ssh\_admin\_username) | The username for the SSH admin for the YBA instance | `string` | n/a | yes |
| <a name="input_yba_ssh_private_key_path"></a> [yba\_ssh\_private\_key\_path](#input\_yba\_ssh\_private\_key\_path) | The path to the private key to use for SSH access to the YBA instance | `string` | n/a | yes |
| <a name="input_yba_subnet_cidr"></a> [yba\_subnet\_cidr](#input\_yba\_subnet\_cidr) | The CIDR block for the YBA subnet | `string` | `"10.0.1.0/24"` | no |
| <a name="input_yba_version"></a> [yba\_version](#input\_yba\_version) | The version of YBA to install | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_network_name"></a> [provider\_network\_name](#output\_provider\_network\_name) | The name of the VPC network created. |
| <a name="output_provider_region"></a> [provider\_region](#output\_provider\_region) | The region to use for subnets. |
| <a name="output_provider_subnet"></a> [provider\_subnet](#output\_provider\_subnet) | The subnet created for the provider |
| <a name="output_yba_hostname"></a> [yba\_hostname](#output\_yba\_hostname) | The hostname of the YBA instance |
| <a name="output_yba_subnet"></a> [yba\_subnet](#output\_yba\_subnet) | The subnet created for YBA |
| <a name="output_yba_url"></a> [yba\_url](#output\_yba\_url) | The URL for YBA. |
<!-- END_TF_DOCS -->
