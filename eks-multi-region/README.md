# Multi-region Yugabyte universe on AWS EKS

## Introduction
This Terraform configuration will create a multi-region Yugabyte universe on AWS EKS. It will create the following objects:

* 2 VPCs in 2 regions
* A peering connection between the 2 regions
* 2 EKS clusters, one in each region
* Istio installed on each EKS cluster, and configured as multicluster _In progress_
* YBA installed on the first EKS cluster _In progress_

## Prerequisites

The following must be done manually prior to applying the configuration:

* Make sure your AWS credentials are able to create IAM policies and roles in your AWS account.
* Install [kubectl](https://kubernetes.io/docs/tasks/tools/) on your workstation
* Install [helm](https://helm.sh/docs/intro/install/) on your workstation
* Install the [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your workstation.
* Install [terrform-docs](https://terraform-docs.io/user-guide/installation/)

## Create your terraform variables file

The easiest way to set the required variables is to use `terraform-docs`
```bash
terraform-docs tfvars hcl . > myvars.auto.tfvars
```

And then edit `myvars.auto.tfvars` to set your configuration variables.

## Installation

Once you have the variables defined, you can apply the configuration as usual:

```bash
terraform init
terraform apply
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_eks_cluster_1"></a> [aws\_eks\_cluster\_1](#module\_aws\_eks\_cluster\_1) | ./modules/aws-eks | n/a |
| <a name="module_aws_eks_cluster_2"></a> [aws\_eks\_cluster\_2](#module\_aws\_eks\_cluster\_2) | ./modules/aws-eks | n/a |
| <a name="module_aws_peering_connection"></a> [aws\_peering\_connection](#module\_aws\_peering\_connection) | ./modules/aws-peering-connection | n/a |
| <a name="module_aws_vpc_1"></a> [aws\_vpc\_1](#module\_aws\_vpc\_1) | ./modules/aws-vpc | n/a |
| <a name="module_aws_vpc_2"></a> [aws\_vpc\_2](#module\_aws\_vpc\_2) | ./modules/aws-vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_customer_tag_value"></a> [customer\_tag\_value](#input\_customer\_tag\_value) | The value for the customer tag for resources | `string` | n/a | yes |
| <a name="input_department_tag_value"></a> [department\_tag\_value](#input\_department\_tag\_value) | The value for the department tag for resources | `string` | n/a | yes |
| <a name="input_eks_kubernetes_version"></a> [eks\_kubernetes\_version](#input\_eks\_kubernetes\_version) | The Kubernetes version to use | `string` | `"1.28"` | no |
| <a name="input_node_group_disk_size"></a> [node\_group\_disk\_size](#input\_node\_group\_disk\_size) | The disk size in GB for worker nodes | `number` | `50` | no |
| <a name="input_node_group_instance_type"></a> [node\_group\_instance\_type](#input\_node\_group\_instance\_type) | The instance type for the worker nodes | `string` | n/a | yes |
| <a name="input_number_of_subnets"></a> [number\_of\_subnets](#input\_number\_of\_subnets) | The number of subnets to create | `number` | `3` | no |
| <a name="input_owner_tag_value"></a> [owner\_tag\_value](#input\_owner\_tag\_value) | The value for the owner tag for resources | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix for resource names | `string` | n/a | yes |
| <a name="input_sales_region_tag_value"></a> [sales\_region\_tag\_value](#input\_sales\_region\_tag\_value) | The value for the sales region tag for resources | `string` | n/a | yes |
| <a name="input_task_tag_value"></a> [task\_tag\_value](#input\_task\_tag\_value) | The value for the task tag for resources | `string` | n/a | yes |
| <a name="input_universe_management_cluster_role"></a> [universe\_management\_cluster\_role](#input\_universe\_management\_cluster\_role) | The name of the universe management cluster role | `string` | n/a | yes |
| <a name="input_universe_management_cluster_role_binding"></a> [universe\_management\_cluster\_role\_binding](#input\_universe\_management\_cluster\_role\_binding) | The name of the universe management cluster role binding | `string` | n/a | yes |
| <a name="input_universe_management_namespace"></a> [universe\_management\_namespace](#input\_universe\_management\_namespace) | The namespace for the universement management sa and role | `string` | n/a | yes |
| <a name="input_universe_management_sa"></a> [universe\_management\_sa](#input\_universe\_management\_sa) | The name of the universe management service account | `string` | n/a | yes |
| <a name="input_vpc_1"></a> [vpc\_1](#input\_vpc\_1) | The first vpc to create | <pre>object({<br>    region     = string<br>    cidr_block = string<br>  })</pre> | n/a | yes |
| <a name="input_vpc_2"></a> [vpc\_2](#input\_vpc\_2) | The second vpc to create | <pre>object({<br>    region     = string<br>    cidr_block = string<br>  })</pre> | n/a | yes |
| <a name="input_yba_namespace"></a> [yba\_namespace](#input\_yba\_namespace) | The name of the namespace for YBA | `string` | n/a | yes |
| <a name="input_yba_pull_secret"></a> [yba\_pull\_secret](#input\_yba\_pull\_secret) | The pull secret for YBA | `string` | n/a | yes |
| <a name="input_yba_role"></a> [yba\_role](#input\_yba\_role) | The name of the YBA role | `string` | n/a | yes |
| <a name="input_yba_role_binding"></a> [yba\_role\_binding](#input\_yba\_role\_binding) | The name of the YBA role binding | `string` | n/a | yes |
| <a name="input_yba_sa"></a> [yba\_sa](#input\_yba\_sa) | The name of the YBA service account | `string` | n/a | yes |
| <a name="input_yba_version"></a> [yba\_version](#input\_yba\_version) | The version of YBA to install | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->