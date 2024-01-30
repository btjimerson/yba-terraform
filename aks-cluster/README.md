# YugabyteDB Anywhere Azure AKS Configuration

## Introduction

This repository contains a Terraform configuration to create an Azure AKS cluster with YugabyteDB Anywhere. By default, this configuration creates:

* An SSH key pair for AKS
* An AKS cluster
* YugabyteDB Anywhere

## Prerequisites

The following must be done manually prior to applying the configuration:

* Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) on your workstation
* Install [kubectl](https://kubernetes.io/docs/tasks/tools/) on your workstation
* Install [helm](https://helm.sh/docs/intro/install/) on your workstation
* Install the [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your workstation
* Install [terrform-docs](https://terraform-docs.io/user-guide/installation/) on your workstation
* Log in to Azure: `az login`

## Installation

First, create a terraform variables file. The easiest way to set the required variables is to use `terraform-docs`
```bash
terraform-docs tfvars hcl . > myvar.auto.tfvars
```
Any variables that are blank will need to be set in a `*.auto.tfvars` or `terraform.tfvars` file. Optionally, you can override variables that have a default value.


Once you have the variables defined you can apply the configuration as usual:

```bash
terraform init
terraform apply
```
If it is successful, you should see an output like this:

```bash
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

client_certificate = <sensitive>
client_key = <sensitive>
cluster_ca_certificate = <sensitive>
cluster_password = <sensitive>
cluster_username = <sensitive>
host = <sensitive>
kube_config = <sensitive>
kubernetes_cluster_name = "bjimerson-aks-cluster"
resource_group_name = "bjimerson-aks-rg"
```

You can use the value for `kube_config` to get the new cluster's context. For example: 

```bash
echo "$(terraform output kube_config)" > $HOME/aks_config
export KUBECONFIG=$HOME/aks_config
```

Note that the `kube_config` may be delimited with a `<<EOT` at the beginning and a `EOT` at the end. Remove these from the kube config file.

To access the YBA Plaform UI, get the IP address of the LoadBalancer service like this:

```
kubectl get svc yugaware-yugaware-ui -n yugabyte -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~>1.5 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_yba"></a> [yba](#module\_yba) | ./modules/yba | n/a |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.ssh_public_key](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource_action.ssh_public_key_gen](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource_action) | resource |
| [azurerm_kubernetes_cluster.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_resource_group.aks_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_kubernetes_cluster.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The username for the Linux admin | `string` | n/a | yes |
| <a name="input_customer_tag_value"></a> [customer\_tag\_value](#input\_customer\_tag\_value) | The value for the customer tag for resources | `string` | n/a | yes |
| <a name="input_department_tag_value"></a> [department\_tag\_value](#input\_department\_tag\_value) | The value for the department tag for resources | `string` | n/a | yes |
| <a name="input_image_registry_email"></a> [image\_registry\_email](#input\_image\_registry\_email) | The email of the server for the Docker image registry | `string` | n/a | yes |
| <a name="input_image_registry_password"></a> [image\_registry\_password](#input\_image\_registry\_password) | The password for the Docker image registry | `string` | n/a | yes |
| <a name="input_image_registry_server"></a> [image\_registry\_server](#input\_image\_registry\_server) | The name of the server for the Docker image registry | `string` | n/a | yes |
| <a name="input_image_registry_username"></a> [image\_registry\_username](#input\_image\_registry\_username) | The username for the Docker image registry | `string` | n/a | yes |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | The number of nodes in the AKS node pool | `number` | n/a | yes |
| <a name="input_node_size"></a> [node\_size](#input\_node\_size) | The machine size for the nodes in the AKS node pool | `string` | n/a | yes |
| <a name="input_owner_tag_value"></a> [owner\_tag\_value](#input\_owner\_tag\_value) | The value for the owner tag for resources | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to create the cluster in | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | A prefix added to all created resources | `string` | n/a | yes |
| <a name="input_sales_region_tag_value"></a> [sales\_region\_tag\_value](#input\_sales\_region\_tag\_value) | The value for the sales region tag for resources | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription ID to use for Azure resources | `string` | n/a | yes |
| <a name="input_task_tag_value"></a> [task\_tag\_value](#input\_task\_tag\_value) | The value for the task tag for resources | `string` | n/a | yes |
| <a name="input_yba_namespace"></a> [yba\_namespace](#input\_yba\_namespace) | The name of the namespace for YBA | `string` | `"yugabyte"` | no |
| <a name="input_yba_role"></a> [yba\_role](#input\_yba\_role) | The name of the YBA role | `string` | `"yba-role"` | no |
| <a name="input_yba_role_binding"></a> [yba\_role\_binding](#input\_yba\_role\_binding) | The name of the YBA role binding | `string` | `"yba-role-binding"` | no |
| <a name="input_yba_sa"></a> [yba\_sa](#input\_yba\_sa) | The name of the YBA service account | `string` | `"yba-sa"` | no |
| <a name="input_yba_universe_management_cluster_role"></a> [yba\_universe\_management\_cluster\_role](#input\_yba\_universe\_management\_cluster\_role) | The name of the universe management cluster role | `string` | `"yugabyte-platform-global-admin"` | no |
| <a name="input_yba_universe_management_cluster_role_binding"></a> [yba\_universe\_management\_cluster\_role\_binding](#input\_yba\_universe\_management\_cluster\_role\_binding) | The name of the universe management cluster role binding | `string` | `"yugabyte-platform-global-admin"` | no |
| <a name="input_yba_universe_management_namespace"></a> [yba\_universe\_management\_namespace](#input\_yba\_universe\_management\_namespace) | The namespace for the universement management sa and role | `string` | `"kube-system"` | no |
| <a name="input_yba_universe_management_sa"></a> [yba\_universe\_management\_sa](#input\_yba\_universe\_management\_sa) | The name of the universe management service account | `string` | `"yugabyte-platform-universe-management"` | no |
| <a name="input_yba_version"></a> [yba\_version](#input\_yba\_version) | The version of YBA to install | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | n/a |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | n/a |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | n/a |
| <a name="output_cluster_password"></a> [cluster\_password](#output\_cluster\_password) | n/a |
| <a name="output_cluster_username"></a> [cluster\_username](#output\_cluster\_username) | n/a |
| <a name="output_host"></a> [host](#output\_host) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#output\_kubernetes\_cluster\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->
