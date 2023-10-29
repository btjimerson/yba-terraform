# Multi-region Yugabyte universe on Google GKE

## Introduction
This Terraform configuration will create a multi-region Yugabyte universe on Google GKE. It will create the following objects:

* A VPC
* 2 subnets, each in a different region
* 2 GKE clusters, one in each subnet / region
* Istio installed on each EKS cluster, and configured as multicluster _In progress_
* YBA installed on the first EKS cluster _In progress_

## Prerequisites

The following must be done manually prior to applying the configuration:

* Install [gcloud](https://cloud.google.com/sdk/docs/install) on your workstation
* Install [kubectl](https://kubernetes.io/docs/tasks/tools/) on your workstation
* Install [helm](https://helm.sh/docs/intro/install/) on your workstation
* Install the [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your workstation.
* Install [terrform-docs](https://terraform-docs.io/user-guide/installation/)
* Initialize the gcloud CLI: `gcloud init`
* Log in to GCP: `gcloud auth application-default login`

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
| <a name="module_google_vpc"></a> [google\_vpc](#module\_google\_vpc) | ./modules/google-vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_customer_tag_value"></a> [customer\_tag\_value](#input\_customer\_tag\_value) | The value for the customer tag for resources | `string` | n/a | yes |
| <a name="input_department_tag_value"></a> [department\_tag\_value](#input\_department\_tag\_value) | The value for the department tag for resources | `string` | n/a | yes |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The GCP project ID to use | `string` | n/a | yes |
| <a name="input_node_machine_type"></a> [node\_machine\_type](#input\_node\_machine\_type) | The machine type to use for the nodes | `string` | n/a | yes |
| <a name="input_number_of_nodes"></a> [number\_of\_nodes](#input\_number\_of\_nodes) | The initial number of nodes in the node pool | `number` | n/a | yes |
| <a name="input_number_of_subnets"></a> [number\_of\_subnets](#input\_number\_of\_subnets) | The number of subnets to create | `number` | n/a | yes |
| <a name="input_owner_tag_value"></a> [owner\_tag\_value](#input\_owner\_tag\_value) | The value for the owner tag for resources | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix for resource names | `string` | n/a | yes |
| <a name="input_sales_region_tag_value"></a> [sales\_region\_tag\_value](#input\_sales\_region\_tag\_value) | The value for the sales region tag for resources | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of subnets to create | <pre>list(object({<br>    cidr_range = string<br>    region     = string<br>  }))</pre> | n/a | yes |
| <a name="input_task_tag_value"></a> [task\_tag\_value](#input\_task\_tag\_value) | The value for the task tag for resources | `string` | n/a | yes |
| <a name="input_universe_management_cluster_role"></a> [universe\_management\_cluster\_role](#input\_universe\_management\_cluster\_role) | The name of the universe management cluster role | `string` | n/a | yes |
| <a name="input_universe_management_cluster_role_binding"></a> [universe\_management\_cluster\_role\_binding](#input\_universe\_management\_cluster\_role\_binding) | The name of the universe management cluster role binding | `string` | n/a | yes |
| <a name="input_universe_management_namespace"></a> [universe\_management\_namespace](#input\_universe\_management\_namespace) | The namespace for the universement management sa and role | `string` | n/a | yes |
| <a name="input_universe_management_sa"></a> [universe\_management\_sa](#input\_universe\_management\_sa) | The name of the universe management service account | `string` | n/a | yes |
| <a name="input_yba_namespace"></a> [yba\_namespace](#input\_yba\_namespace) | The name of the namespace for YBA | `string` | n/a | yes |
| <a name="input_yba_pull_secret"></a> [yba\_pull\_secret](#input\_yba\_pull\_secret) | The pull secret for YBA | `string` | n/a | yes |
| <a name="input_yba_version"></a> [yba\_version](#input\_yba\_version) | The version of YBA to install | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->