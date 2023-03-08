# Yugabyte Platform GKE Configuration for Anthos Config Management

## Introduction

This repository contains a Terraform configuration to create a GKE cluster with YugabyteDB Anywhere and registers the cluster with Anthos Config Management (ACM).  By default, this configuration creates:

* A VPC
* A public subnet in the VPC
* A GKE cluster
* An ACM configuration to deploy / manage YBA in the cluster 

## Prerequisites

The following must be done manually prior to applying the configuration:

* Install [gcloud] (https://cloud.google.com/sdk/docs/install) on your workstation
* Install [kubectl] (https://kubernetes.io/docs/tasks/tools/) on your workstation
* Install the [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your workstation
* Initialize the gcloud CLI: `gcloud init`
* Log in to GCP: `gcloud auth application-default login`

## Installation

Once you have the variables defined and have copied the file `variables.tfvars.example` to something like `myvars.auto.tfvars`, you can apply the configuration as usual:

```
terraform init
terraform apply
```
If it is successful, you should see an output like this:

```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

configure_kubectl_command = "gcloud container clusters get-credentials my-acm-cluster --region us-central1 --project my-project"
```

You can use the value for `configure_kubectl_command` to add the new cluster's context to your configuration and set it as the default context.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.51.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | 4.51.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.17.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke_auth"></a> [gke\_auth](#module\_gke\_auth) | terraform-google-modules/kubernetes-engine/google//modules/auth | n/a |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_container_cluster.cluster](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_container_cluster) | resource |
| [google-beta_google_container_node_pool.primary_node_pool](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_container_node_pool) | resource |
| [google-beta_google_gke_hub_feature_membership.feature_member](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_gke_hub_feature_membership) | resource |
| [google-beta_google_gke_hub_membership.membership](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_gke_hub_membership) | resource |
| [google_compute_network.vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [kubernetes_secret.git_creds](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_config_sync_source_format"></a> [acm\_config\_sync\_source\_format](#input\_acm\_config\_sync\_source\_format) | The config sync source format (one of hierarchical \| unstructured) | `string` | `"unstructured"` | no |
| <a name="input_acm_git_repo"></a> [acm\_git\_repo](#input\_acm\_git\_repo) | The git repo URL for Anthos config management | `string` | n/a | yes |
| <a name="input_acm_namespace"></a> [acm\_namespace](#input\_acm\_namespace) | The name of the ACM default namespace | `string` | `"config-management-system"` | no |
| <a name="input_acm_repo_authentication"></a> [acm\_repo\_authentication](#input\_acm\_repo\_authentication) | The secret type for the ACM repo | `string` | `"none"` | no |
| <a name="input_acm_repo_branch"></a> [acm\_repo\_branch](#input\_acm\_repo\_branch) | The repo branch to sync for ACM | `string` | `"main"` | no |
| <a name="input_acm_repo_pat"></a> [acm\_repo\_pat](#input\_acm\_repo\_pat) | The personal access token for authentication to Git (only required if authentication is token) | `string` | `""` | no |
| <a name="input_acm_repo_username"></a> [acm\_repo\_username](#input\_acm\_repo\_username) | The username to use for authentication to Git (only required if authentication is token) | `string` | `""` | no |
| <a name="input_customer_tag_value"></a> [customer\_tag\_value](#input\_customer\_tag\_value) | The value for the customer tag for resources | `string` | n/a | yes |
| <a name="input_department_tag_value"></a> [department\_tag\_value](#input\_department\_tag\_value) | The value for the department tag for resources | `string` | n/a | yes |
| <a name="input_node_pool_disk_size"></a> [node\_pool\_disk\_size](#input\_node\_pool\_disk\_size) | The size in GB for the node pool's machine disk | `number` | n/a | yes |
| <a name="input_node_pool_disk_type"></a> [node\_pool\_disk\_type](#input\_node\_pool\_disk\_type) | The disk type to use for the node pool's machine disk (one of pd-standard \| pd-balanced \| pd-ssd) | `string` | `"pd-standard"` | no |
| <a name="input_node_pool_machine_type"></a> [node\_pool\_machine\_type](#input\_node\_pool\_machine\_type) | The machine type to use for the default node pool | `string` | n/a | yes |
| <a name="input_node_pool_size"></a> [node\_pool\_size](#input\_node\_pool\_size) | The number of nodes in the default node pool (per zone) | `number` | `1` | no |
| <a name="input_owner_tag_value"></a> [owner\_tag\_value](#input\_owner\_tag\_value) | The value for the owner tag for resources | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to create the cluster in | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | A prefix added to all created resources | `string` | n/a | yes |
| <a name="input_sales_region_tag_value"></a> [sales\_region\_tag\_value](#input\_sales\_region\_tag\_value) | The value for the sales region tag for resources | `string` | n/a | yes |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | The CIDR range for the new subnet | `string` | `"10.1.0.0/24"` | no |
| <a name="input_task_tag_value"></a> [task\_tag\_value](#input\_task\_tag\_value) | The value for the task tag for resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_configure_kubectl_command"></a> [configure\_kubectl\_command](#output\_configure\_kubectl\_command) | Run this command to configure kubectl to use this cluster |
| <a name="output_kubeconfig_raw"></a> [kubeconfig\_raw](#output\_kubeconfig\_raw) | The raw kubeconfig text. This is considered sensitive; it can be viewed with 'terraform output kubeconfig\_raw' |
<!-- END_TF_DOCS -->
