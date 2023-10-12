# Yugabyte Anywhere AWS Single Region Configuration

## Introduction

This repository contains a Terraform configuration to create a single-region AWS environment with Yugabyte Platform.  By default, this configuration creates:

* A VPC in one region for YBA and universes
* Public and private subnets in the VPC
* A security group for the VPC to allow the required YugabyteDB traffic
* An EC2 instance with YBA installed
* A security group for the VPC to allow traffic to universe nodes

Once this configuration is applied, you are ready to install Yugabyte Platform, single-region AWS cloud provider, and the corresponding Universe.

## Prerequisites

The following must be done manually prior to applying the configuration:

* Create a keypair in the region where you are going to install Yugabyte Platform.  This is used for SSH access to the EC2 instance.
* Make sure your AWS credentials are able to create IAM policies and roles in your AWS account.
* Install the [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your workstation.
* [terrform-docs](https://terraform-docs.io/user-guide/installation/)

## Create your terraform variables file
The easiest way to set the required variables is to use `terraform-docs`
```bash
terraform-docs tfvars hcl . > myvars.auto.tfvars
```

And edit `myvars.auto.tfvars` to set the variables correctly.   ``

## Installation

Once you have the variables defined and have renamed the file `variables.tfvars.example` to something like `myvars.auto.tfvars`, you can apply the configuration as usual:

```
terraform init
terraform apply
```
If it is successful, you should see an output like this:

```
Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

public_subnets = [
  "us-east-2a: subnet-060910ce88115a18d",
  "us-east-2b: subnet-09b79808bedb8b01d",
  "us-east-2c: subnet-04e1b4848ad28a813",
]
region_name = "us-east-2"
universe_security_group_id = "sg-03b2c582a07563a5b"
vpc_id = "vpc-0394c47419c02cc1d"
yba_api_token = <sensitive>
yba_ip_address = "18.227.89.83"
yba_url = "https://18.227.89.83"

```

These outputs can be used to configure a cloud provider for AWS in YBA, either through the UI or another Terraform configuration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_yb_pcx_yba_region_yb_region"></a> [yb\_pcx\_yba\_region\_yb\_region](#module\_yb\_pcx\_yba\_region\_yb\_region) | ./modules/yba-pcx | n/a |
| <a name="module_yb_platform"></a> [yb\_platform](#module\_yb\_platform) | ./modules/yba | n/a |
| <a name="module_yb_vpc_region"></a> [yb\_vpc\_region](#module\_yb\_vpc\_region) | ./modules/yba-vpc | n/a |

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
| <a name="input_task_tag_value"></a> [task\_tag\_value](#input\_task\_tag\_value) | The value for the task tag for resources | `string` | n/a | yes |
| <a name="input_yb_private_subnet_1_cidr_block"></a> [yb\_private\_subnet\_1\_cidr\_block](#input\_yb\_private\_subnet\_1\_cidr\_block) | CIDR block for the regions 1st private subnet | `string` | n/a | yes |
| <a name="input_yb_private_subnet_1_zone"></a> [yb\_private\_subnet\_1\_zone](#input\_yb\_private\_subnet\_1\_zone) | The availability zone for the regions 1st private subnet | `string` | n/a | yes |
| <a name="input_yb_public_subnet_1_cidr_block"></a> [yb\_public\_subnet\_1\_cidr\_block](#input\_yb\_public\_subnet\_1\_cidr\_block) | CIDR block for the regions 1st public subnet | `string` | n/a | yes |
| <a name="input_yb_public_subnet_1_zone"></a> [yb\_public\_subnet\_1\_zone](#input\_yb\_public\_subnet\_1\_zone) | The availability zone for the regions 1st public subnet | `string` | n/a | yes |
| <a name="input_yb_public_subnet_2_cidr_block"></a> [yb\_public\_subnet\_2\_cidr\_block](#input\_yb\_public\_subnet\_2\_cidr\_block) | CIDR block for the regions 2nd public subnet | `string` | n/a | yes |
| <a name="input_yb_public_subnet_2_zone"></a> [yb\_public\_subnet\_2\_zone](#input\_yb\_public\_subnet\_2\_zone) | The availability zone for the regions 2nd public subnet | `string` | n/a | yes |
| <a name="input_yb_public_subnet_3_cidr_block"></a> [yb\_public\_subnet\_3\_cidr\_block](#input\_yb\_public\_subnet\_3\_cidr\_block) | CIDR block for the regions 3rd public subnet | `string` | n/a | yes |
| <a name="input_yb_public_subnet_3_zone"></a> [yb\_public\_subnet\_3\_zone](#input\_yb\_public\_subnet\_3\_zone) | The availability zone for the regions 3rd public subnet | `string` | n/a | yes |
| <a name="input_yb_region"></a> [yb\_region](#input\_yb\_region) | AWS Region for yb nodes | `string` | n/a | yes |
| <a name="input_yb_security_groups_external_source_cidr"></a> [yb\_security\_groups\_external\_source\_cidr](#input\_yb\_security\_groups\_external\_source\_cidr) | Source CIDR block of external access for the security groups | `string` | n/a | yes |
| <a name="input_yb_vpc_cidr_block"></a> [yb\_vpc\_cidr\_block](#input\_yb\_vpc\_cidr\_block) | CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_yba_ami_filter"></a> [yba\_ami\_filter](#input\_yba\_ami\_filter) | A string to filter for the Yugabyte Platform AMI | `string` | n/a | yes |
| <a name="input_yba_ami_owner"></a> [yba\_ami\_owner](#input\_yba\_ami\_owner) | The owner of the AMI to use for Yugabyte Platform | `string` | n/a | yes |
| <a name="input_yba_instance_type"></a> [yba\_instance\_type](#input\_yba\_instance\_type) | The instance type to use for Yugabyte Platform | `string` | n/a | yes |
| <a name="input_yba_instance_volume_size"></a> [yba\_instance\_volume\_size](#input\_yba\_instance\_volume\_size) | The size of the Yugabyte Platform EC2 instance's root disk, in GB | `number` | n/a | yes |
| <a name="input_yba_instance_volume_type"></a> [yba\_instance\_volume\_type](#input\_yba\_instance\_volume\_type) | The type of the Yugabyte Platform EC2 instance's root disk | `string` | `"gp2"` | no |
| <a name="input_yba_keypair_name"></a> [yba\_keypair\_name](#input\_yba\_keypair\_name) | Keypair name for the Yugabyte Platform EC2 instance.  This keypair needs to be created in the Yugabyte Platform region; it is used for SSH access to the Yugabyte Platform instance. | `string` | n/a | yes |
| <a name="input_yba_private_subnet_cidr_block"></a> [yba\_private\_subnet\_cidr\_block](#input\_yba\_private\_subnet\_cidr\_block) | CIDR block for the Yugabyte Platform private subnet | `string` | n/a | yes |
| <a name="input_yba_private_subnet_zone"></a> [yba\_private\_subnet\_zone](#input\_yba\_private\_subnet\_zone) | The availability zone for the Yugabyte Platform private subnet | `string` | n/a | yes |
| <a name="input_yba_public_subnet_cidr_block"></a> [yba\_public\_subnet\_cidr\_block](#input\_yba\_public\_subnet\_cidr\_block) | CIDR block for the Yugabyte Platform public subnet | `string` | n/a | yes |
| <a name="input_yba_public_subnet_zone"></a> [yba\_public\_subnet\_zone](#input\_yba\_public\_subnet\_zone) | The availability zone for the Yugabyte Platform public subnet | `string` | n/a | yes |
| <a name="input_yba_region"></a> [yba\_region](#input\_yba\_region) | AWS Region for Yugabyte Platform | `string` | n/a | yes |
| <a name="input_yba_vpc_cidr_block"></a> [yba\_vpc\_cidr\_block](#input\_yba\_vpc\_cidr\_block) | CIDR block for the Yugabyte Platform VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_region_name"></a> [region\_name](#output\_region\_name) | The name of the VPC region |
| <a name="output_region_public_subnet_1_id"></a> [region\_public\_subnet\_1\_id](#output\_region\_public\_subnet\_1\_id) | The ID of the 1st public subnet |
| <a name="output_region_public_subnet_2_id"></a> [region\_public\_subnet\_2\_id](#output\_region\_public\_subnet\_2\_id) | The ID of the 2nd public subnet |
| <a name="output_region_public_subnet_3_id"></a> [region\_public\_subnet\_3\_id](#output\_region\_public\_subnet\_3\_id) | The ID of the 3rd public subnet |
| <a name="output_region_public_zone_1"></a> [region\_public\_zone\_1](#output\_region\_public\_zone\_1) | The availability zone of the 1st public subnet |
| <a name="output_region_public_zone_2"></a> [region\_public\_zone\_2](#output\_region\_public\_zone\_2) | The availability zone of the 2nd public subnet |
| <a name="output_region_public_zone_3"></a> [region\_public\_zone\_3](#output\_region\_public\_zone\_3) | The availability zone of the 3rd public subnet |
| <a name="output_region_security_group_id"></a> [region\_security\_group\_id](#output\_region\_security\_group\_id) | The ID of the Yugabyte security group |
| <a name="output_region_vpc_id"></a> [region\_vpc\_id](#output\_region\_vpc\_id) | The ID of the VPC |
| <a name="output_yba_replicated_url"></a> [yba\_replicated\_url](#output\_yba\_replicated\_url) | Replicated URL |
<!-- END_TF_DOCS -->
