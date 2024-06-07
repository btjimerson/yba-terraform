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

First, set an environment variable called `YB_CUSTOMER_PASSWORD`. This will be the password for the YBA admin user, so it needs to follow the password rules in YBA.

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_yba"></a> [yba](#requirement\_yba) | 0.1.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_yba.unauthenticated"></a> [yba.unauthenticated](#provider\_yba.unauthenticated) | 0.1.11 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.yba_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.yba_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.yba_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.yba_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.yba](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.yb_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.yb_public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.yb_public_subnets_to_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.universe_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.yba_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.yb_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.yb_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.yb_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [yba_customer_resource.yba_admin](https://registry.terraform.io/providers/yugabyte/yba/0.1.11/docs/resources/customer_resource) | resource |
| [yba_installer.yba](https://registry.terraform.io/providers/yugabyte/yba/0.1.11/docs/resources/installer) | resource |
| [aws_ami.yba_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_customer_tag_value"></a> [customer\_tag\_value](#input\_customer\_tag\_value) | The value for the customer tag for resources | `string` | n/a | yes |
| <a name="input_department_tag_value"></a> [department\_tag\_value](#input\_department\_tag\_value) | The value for the department tag for resources | `string` | n/a | yes |
| <a name="input_owner_tag_value"></a> [owner\_tag\_value](#input\_owner\_tag\_value) | The value for the owner tag for resources | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | The private subnets to create | <pre>map(object({<br>    cidr_block = string<br>    zone       = string<br>  }))</pre> | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | The public subnets to create | <pre>map(object({<br>    cidr_block = string<br>    zone       = string<br>  }))</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region for to install in | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix for resource names | `string` | n/a | yes |
| <a name="input_sales_region_tag_value"></a> [sales\_region\_tag\_value](#input\_sales\_region\_tag\_value) | The value for the sales region tag for resources | `string` | n/a | yes |
| <a name="input_security_groups_external_source_cidr"></a> [security\_groups\_external\_source\_cidr](#input\_security\_groups\_external\_source\_cidr) | Source CIDR block of external access for the security groups | `string` | n/a | yes |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | The path to your private SSH key | `string` | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | The SSH username. | `string` | n/a | yes |
| <a name="input_task_tag_value"></a> [task\_tag\_value](#input\_task\_tag\_value) | The value for the task tag for resources | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_yba_admin_email"></a> [yba\_admin\_email](#input\_yba\_admin\_email) | The email address for the admin user (used to log in to YBA) | `string` | n/a | yes |
| <a name="input_yba_admin_name"></a> [yba\_admin\_name](#input\_yba\_admin\_name) | The name of the admin user for YBA | `string` | n/a | yes |
| <a name="input_yba_ami_id"></a> [yba\_ami\_id](#input\_yba\_ami\_id) | The ID for the YBA AMI | `string` | n/a | yes |
| <a name="input_yba_instance_type"></a> [yba\_instance\_type](#input\_yba\_instance\_type) | The instance type to use for YBA | `string` | n/a | yes |
| <a name="input_yba_instance_volume_size"></a> [yba\_instance\_volume\_size](#input\_yba\_instance\_volume\_size) | The size of the YBA EC2 instance's root disk, in GB | `number` | n/a | yes |
| <a name="input_yba_instance_volume_type"></a> [yba\_instance\_volume\_type](#input\_yba\_instance\_volume\_type) | The type of the YBA EC2 instance's root disk | `string` | `"gp2"` | no |
| <a name="input_yba_keypair_name"></a> [yba\_keypair\_name](#input\_yba\_keypair\_name) | Keypair name for the YBA EC2 instance.  This keypair needs to be created in the YBA region; it is used for SSH access to the YBA instance. | `string` | n/a | yes |
| <a name="input_yba_license_file"></a> [yba\_license\_file](#input\_yba\_license\_file) | The path to the license file for YBA | `string` | n/a | yes |
| <a name="input_yba_settings_file"></a> [yba\_settings\_file](#input\_yba\_settings\_file) | The path to the settings file for YBA | `string` | `""` | no |
| <a name="input_yba_version"></a> [yba\_version](#input\_yba\_version) | The version of YBA to install (including build number) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | The public subnets created |
| <a name="output_region_name"></a> [region\_name](#output\_region\_name) | The name of the VPC region |
| <a name="output_universe_security_group_id"></a> [universe\_security\_group\_id](#output\_universe\_security\_group\_id) | The ID of the universe security group |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_yba_api_token"></a> [yba\_api\_token](#output\_yba\_api\_token) | The API token for the admin user |
| <a name="output_yba_ip_address"></a> [yba\_ip\_address](#output\_yba\_ip\_address) | The IP address of YBA |
| <a name="output_yba_url"></a> [yba\_url](#output\_yba\_url) | The URL for the YBA UI |
<!-- END_TF_DOCS -->
