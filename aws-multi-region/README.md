# Yugabyte Platform AWS Multi-region Configuration

## Introduction

This repository contains a Terraform configuration to create a multi-region AWS environment with Yugabyte Platform.  By default, this configuration creates:

* 3 VPCs in 3 regions
* A public and a private subnet in each VPC
* A security group for each VPC to allow the required YugabyteDB traffic
* A peering connection between each VPC
* A VPC dedicated to Yugabyte Platform
* A peering connection between the Yugabyte Platform VPC and each node VPC
* An EC2 instance with Replicated installed to install Yugabyte Platform

Once this configuration is applied, you are ready to install Yugabyte Platform, multi-region AWS cloud provider, and the corresponding Universe.

## Prerequisites

The following must be done manually prior to applying the configuration:

* Create a keypair in the region where you are going to install Yugabyte Platform.  This is used for SSH access to the EC2 instance.
* Make sure your AWS credentials are able to create IAM policies and roles in your AWS account.
* Install the [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your workstation.

## Installation

Once you have the variables defined and have renamed the file `variables.tfvars.example` to something like `myvars.auto.tfvars`, you can apply the configuration as usual:

```
terraform init
terraform apply
```
If it is successful, you should see an output like this:

```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

region_1_name = "us-east-2"
region_1_public_subnet_id = "subnet-0ac609de8a6c12430"
region_1_public_zone = "us-east-2a"
region_1_security_group_id = "sg-0a49506d7c8f1f594"
region_1_vpc_id = "vpc-040f9cf14bf52bc80"
region_2_name = "eu-west-2"
region_2_public_subnet_id = "subnet-04d6273732e614826"
region_2_public_zone = "eu-west-2a"
region_2_security_group_id = "sg-0e57bd9f0bfa09e1a"
region_2_vpc_id = "vpc-0b96401d1d515448b"
region_3_name = "ap-southeast-1"
region_3_public_subnet_id = "subnet-0719e578f24c549bc"
region_3_public_zone = "ap-southeast-1a"
region_3_security_group_id = "sg-03a7d99dc92ee2d38"
region_3_vpc_id = "vpc-0a2da88cd7e424d20"
yba_replicated_url = "http://3.145.18.72:8800"
```

You can open the output for `yba_replicated_url` in a browser and continue installation as usual (note that it may take a few minutes for Replicated to install and start).  The other outputs can be used when creating the AWS cloud provider.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_yba"></a> [yba](#requirement\_yba) | 0.1.11 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_yb_pcx_region_1_region_2"></a> [yb\_pcx\_region\_1\_region\_2](#module\_yb\_pcx\_region\_1\_region\_2) | ./modules/yba-pcx | n/a |
| <a name="module_yb_pcx_region_1_region_3"></a> [yb\_pcx\_region\_1\_region\_3](#module\_yb\_pcx\_region\_1\_region\_3) | ./modules/yba-pcx | n/a |
| <a name="module_yb_pcx_region_2_region_3"></a> [yb\_pcx\_region\_2\_region\_3](#module\_yb\_pcx\_region\_2\_region\_3) | ./modules/yba-pcx | n/a |
| <a name="module_yb_pcx_yba_region_1"></a> [yb\_pcx\_yba\_region\_1](#module\_yb\_pcx\_yba\_region\_1) | ./modules/yba-pcx | n/a |
| <a name="module_yb_pcx_yba_region_2"></a> [yb\_pcx\_yba\_region\_2](#module\_yb\_pcx\_yba\_region\_2) | ./modules/yba-pcx | n/a |
| <a name="module_yb_pcx_yba_region_3"></a> [yb\_pcx\_yba\_region\_3](#module\_yb\_pcx\_yba\_region\_3) | ./modules/yba-pcx | n/a |
| <a name="module_yb_vpc_region_1"></a> [yb\_vpc\_region\_1](#module\_yb\_vpc\_region\_1) | ./modules/yba-vpc | n/a |
| <a name="module_yb_vpc_region_2"></a> [yb\_vpc\_region\_2](#module\_yb\_vpc\_region\_2) | ./modules/yba-vpc | n/a |
| <a name="module_yb_vpc_region_3"></a> [yb\_vpc\_region\_3](#module\_yb\_vpc\_region\_3) | ./modules/yba-vpc | n/a |
| <a name="module_yba"></a> [yba](#module\_yba) | ./modules/yba | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_customer_tag_value"></a> [customer\_tag\_value](#input\_customer\_tag\_value) | The value for the customer tag for resources | `string` | n/a | yes |
| <a name="input_department_tag_value"></a> [department\_tag\_value](#input\_department\_tag\_value) | The value for the department tag for resources | `string` | n/a | yes |
| <a name="input_owner_tag_value"></a> [owner\_tag\_value](#input\_owner\_tag\_value) | The value for the owner tag for resources | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix for resource names | `string` | n/a | yes |
| <a name="input_sales_region_tag_value"></a> [sales\_region\_tag\_value](#input\_sales\_region\_tag\_value) | The value for the sales region tag for resources | `string` | n/a | yes |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | The path to the private key for ssh | `string` | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | The username for ssh | `string` | n/a | yes |
| <a name="input_task_tag_value"></a> [task\_tag\_value](#input\_task\_tag\_value) | The value for the task tag for resources | `string` | n/a | yes |
| <a name="input_yb_region_1_private_subnet_cidr_block"></a> [yb\_region\_1\_private\_subnet\_cidr\_block](#input\_yb\_region\_1\_private\_subnet\_cidr\_block) | CIDR block for the region 1 private subnet | `string` | n/a | yes |
| <a name="input_yb_region_1_private_subnet_zone"></a> [yb\_region\_1\_private\_subnet\_zone](#input\_yb\_region\_1\_private\_subnet\_zone) | The availability zone for the region 1 private subnet | `string` | n/a | yes |
| <a name="input_yb_region_1_public_subnet_cidr_block"></a> [yb\_region\_1\_public\_subnet\_cidr\_block](#input\_yb\_region\_1\_public\_subnet\_cidr\_block) | CIDR block for the region 1 public subnet | `string` | n/a | yes |
| <a name="input_yb_region_1_public_subnet_zone"></a> [yb\_region\_1\_public\_subnet\_zone](#input\_yb\_region\_1\_public\_subnet\_zone) | The availability zone for the region 1 public subnet | `string` | n/a | yes |
| <a name="input_yb_region_1_region"></a> [yb\_region\_1\_region](#input\_yb\_region\_1\_region) | AWS Region for region 1 | `string` | n/a | yes |
| <a name="input_yb_region_1_vpc_cidr_block"></a> [yb\_region\_1\_vpc\_cidr\_block](#input\_yb\_region\_1\_vpc\_cidr\_block) | CIDR block for the region 1 VPC | `string` | n/a | yes |
| <a name="input_yb_region_2_private_subnet_cidr_block"></a> [yb\_region\_2\_private\_subnet\_cidr\_block](#input\_yb\_region\_2\_private\_subnet\_cidr\_block) | CIDR block for the region 2 private subnet | `string` | n/a | yes |
| <a name="input_yb_region_2_private_subnet_zone"></a> [yb\_region\_2\_private\_subnet\_zone](#input\_yb\_region\_2\_private\_subnet\_zone) | The availability zone for the region 2 private subnet | `string` | n/a | yes |
| <a name="input_yb_region_2_public_subnet_cidr_block"></a> [yb\_region\_2\_public\_subnet\_cidr\_block](#input\_yb\_region\_2\_public\_subnet\_cidr\_block) | CIDR block for the region 2 public subnet | `string` | n/a | yes |
| <a name="input_yb_region_2_public_subnet_zone"></a> [yb\_region\_2\_public\_subnet\_zone](#input\_yb\_region\_2\_public\_subnet\_zone) | The availability zone for the region 2 public subnet | `string` | n/a | yes |
| <a name="input_yb_region_2_region"></a> [yb\_region\_2\_region](#input\_yb\_region\_2\_region) | AWS Region for region 2 | `string` | n/a | yes |
| <a name="input_yb_region_2_vpc_cidr_block"></a> [yb\_region\_2\_vpc\_cidr\_block](#input\_yb\_region\_2\_vpc\_cidr\_block) | CIDR block for the region 2 VPC | `string` | n/a | yes |
| <a name="input_yb_region_3_private_subnet_cidr_block"></a> [yb\_region\_3\_private\_subnet\_cidr\_block](#input\_yb\_region\_3\_private\_subnet\_cidr\_block) | CIDR block for the region 3 private subnet | `string` | n/a | yes |
| <a name="input_yb_region_3_private_subnet_zone"></a> [yb\_region\_3\_private\_subnet\_zone](#input\_yb\_region\_3\_private\_subnet\_zone) | The availability zone for the region 3 private subnet | `string` | n/a | yes |
| <a name="input_yb_region_3_public_subnet_cidr_block"></a> [yb\_region\_3\_public\_subnet\_cidr\_block](#input\_yb\_region\_3\_public\_subnet\_cidr\_block) | CIDR block for the region 3 public subnet | `string` | n/a | yes |
| <a name="input_yb_region_3_public_subnet_zone"></a> [yb\_region\_3\_public\_subnet\_zone](#input\_yb\_region\_3\_public\_subnet\_zone) | The availability zone for the region 3 public subnet | `string` | n/a | yes |
| <a name="input_yb_region_3_region"></a> [yb\_region\_3\_region](#input\_yb\_region\_3\_region) | AWS Region for region 3 | `string` | n/a | yes |
| <a name="input_yb_region_3_vpc_cidr_block"></a> [yb\_region\_3\_vpc\_cidr\_block](#input\_yb\_region\_3\_vpc\_cidr\_block) | CIDR block for the region 3 VPC | `string` | n/a | yes |
| <a name="input_yb_security_groups_external_source_cidr"></a> [yb\_security\_groups\_external\_source\_cidr](#input\_yb\_security\_groups\_external\_source\_cidr) | Source CIDR block of external access for the security groups | `string` | n/a | yes |
| <a name="input_yba_admin_email"></a> [yba\_admin\_email](#input\_yba\_admin\_email) | The email addrss for the YBA admin | `string` | n/a | yes |
| <a name="input_yba_admin_name"></a> [yba\_admin\_name](#input\_yba\_admin\_name) | The name of the YBA admin | `string` | n/a | yes |
| <a name="input_yba_ami_filter"></a> [yba\_ami\_filter](#input\_yba\_ami\_filter) | A string to filter for the Yugabyte Platform AMI | `string` | n/a | yes |
| <a name="input_yba_ami_owner"></a> [yba\_ami\_owner](#input\_yba\_ami\_owner) | The owner of the AMI to use for Yugabyte Platform | `string` | n/a | yes |
| <a name="input_yba_instance_type"></a> [yba\_instance\_type](#input\_yba\_instance\_type) | The instance type to use for Yugabyte Platform | `string` | n/a | yes |
| <a name="input_yba_instance_volume_size"></a> [yba\_instance\_volume\_size](#input\_yba\_instance\_volume\_size) | The size of the Yugabyte Platform EC2 instance's root disk, in GB | `number` | n/a | yes |
| <a name="input_yba_instance_volume_type"></a> [yba\_instance\_volume\_type](#input\_yba\_instance\_volume\_type) | The type of the Yugabyte Platform EC2 instance's root disk | `string` | `"gp2"` | no |
| <a name="input_yba_keypair_name"></a> [yba\_keypair\_name](#input\_yba\_keypair\_name) | Keypair name for the Yugabyte Platform EC2 instance.  This keypair needs to be created in the Yugabyte Platform region; it is used for SSH access to the Yugabyte Platform instance. | `string` | n/a | yes |
| <a name="input_yba_license_file"></a> [yba\_license\_file](#input\_yba\_license\_file) | The license file for the YBA installer | `string` | n/a | yes |
| <a name="input_yba_private_subnet_cidr_block"></a> [yba\_private\_subnet\_cidr\_block](#input\_yba\_private\_subnet\_cidr\_block) | CIDR block for the Yugabyte Platform private subnet | `string` | n/a | yes |
| <a name="input_yba_private_subnet_zone"></a> [yba\_private\_subnet\_zone](#input\_yba\_private\_subnet\_zone) | The availability zone for the Yugabyte Platform private subnet | `string` | n/a | yes |
| <a name="input_yba_public_subnet_cidr_block"></a> [yba\_public\_subnet\_cidr\_block](#input\_yba\_public\_subnet\_cidr\_block) | CIDR block for the Yugabyte Platform public subnet | `string` | n/a | yes |
| <a name="input_yba_public_subnet_zone"></a> [yba\_public\_subnet\_zone](#input\_yba\_public\_subnet\_zone) | The availability zone for the Yugabyte Platform public subnet | `string` | n/a | yes |
| <a name="input_yba_region"></a> [yba\_region](#input\_yba\_region) | AWS Region for Yugabyte Platform | `string` | n/a | yes |
| <a name="input_yba_settings_file"></a> [yba\_settings\_file](#input\_yba\_settings\_file) | The settings for the YBA installer | `string` | n/a | yes |
| <a name="input_yba_version"></a> [yba\_version](#input\_yba\_version) | The version of YBA to install | `string` | n/a | yes |
| <a name="input_yba_vpc_cidr_block"></a> [yba\_vpc\_cidr\_block](#input\_yba\_vpc\_cidr\_block) | CIDR block for the Yugabyte Platform VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_region_1_name"></a> [region\_1\_name](#output\_region\_1\_name) | The name of the first VPC region |
| <a name="output_region_1_public_subnet_id"></a> [region\_1\_public\_subnet\_id](#output\_region\_1\_public\_subnet\_id) | The ID of the public subnet in the first region |
| <a name="output_region_1_public_zone"></a> [region\_1\_public\_zone](#output\_region\_1\_public\_zone) | The availability zone of the public subnet in the first region |
| <a name="output_region_1_security_group_id"></a> [region\_1\_security\_group\_id](#output\_region\_1\_security\_group\_id) | The ID of the Yugabyte security group in the first region |
| <a name="output_region_1_vpc_id"></a> [region\_1\_vpc\_id](#output\_region\_1\_vpc\_id) | The ID of the VPC for the first region |
| <a name="output_region_2_name"></a> [region\_2\_name](#output\_region\_2\_name) | The name of the second VPC region |
| <a name="output_region_2_public_subnet_id"></a> [region\_2\_public\_subnet\_id](#output\_region\_2\_public\_subnet\_id) | The ID of the public subnet in the second region |
| <a name="output_region_2_public_zone"></a> [region\_2\_public\_zone](#output\_region\_2\_public\_zone) | The availability zone of the public subnet in the second region |
| <a name="output_region_2_security_group_id"></a> [region\_2\_security\_group\_id](#output\_region\_2\_security\_group\_id) | The ID of the Yugabyte security group in the second region |
| <a name="output_region_2_vpc_id"></a> [region\_2\_vpc\_id](#output\_region\_2\_vpc\_id) | The ID of the VPC for the second region |
| <a name="output_region_3_name"></a> [region\_3\_name](#output\_region\_3\_name) | The name of the third VPC region |
| <a name="output_region_3_public_subnet_id"></a> [region\_3\_public\_subnet\_id](#output\_region\_3\_public\_subnet\_id) | The ID of the public subnet in the third region |
| <a name="output_region_3_public_zone"></a> [region\_3\_public\_zone](#output\_region\_3\_public\_zone) | The availability zone of the public subnet in the third region |
| <a name="output_region_3_security_group_id"></a> [region\_3\_security\_group\_id](#output\_region\_3\_security\_group\_id) | The ID of the Yugabyte security group in the third region |
| <a name="output_region_3_vpc_id"></a> [region\_3\_vpc\_id](#output\_region\_3\_vpc\_id) | The ID of the VPC for the third region |
| <a name="output_yba_ip_address"></a> [yba\_ip\_address](#output\_yba\_ip\_address) | The IP address of YBA |
| <a name="output_yba_url"></a> [yba\_url](#output\_yba\_url) | The URL for the YBA UI |
<!-- END_TF_DOCS -->
