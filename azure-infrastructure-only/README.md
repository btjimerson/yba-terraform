# Azure Single Region - Infrastructure Only

## Introduction

This repository contains a Terraform configuration to create a single-region Azure environment with YugabyteDB Anywhere.  By default, this configuration creates:

* A resource group in one region.
* A virtual network in the resource group.
* A subnet in the virtual network for YBA.
* A security group to allow the required traffic to YBA.
* A public IP address for the YBA VM.
* One or more subnets in the virtual network for YB universes.
* A virtual machine that you can use to install YBA.
* An application registration and client secret to use for the cloud provider config.

Once this configuration is applied, you are ready to install YugabyteDB Anywhere, a single-region azure cloud provider, and the corresponding Universe.

## Prerequisites

The following must be done manually prior to applying the configuration:

* Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) on your workstation.
* Sign into Azure: `az login -u <username> -p <password`
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
If it is successful, you should see an output like this:

```bash
Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Outputs:

provider_application_client_id = "b9d9cf53-603c-4a2d-a820-bd314a3d0dd2"
provider_application_client_secret = <sensitive>
provider_region_subnet_names = [
  "bjimerson-yba-demo-universe-subnet-1",
  "bjimerson-yba-demo-universe-subnet-2",
  "bjimerson-yba-demo-universe-subnet-3",
]
provider_region_virtual_network_name = "bjimerson-yba-demo-vnet"
provider_resource_group = "bjimerson-yba-demo-rg"
provider_subscription_id = "abcdefghijklmnop"
provider_tenant_id = "abcdefghijklmnop"
yba_ip_address = "20.51.244.83"

```

You can use the outputs that start with `provider_` to configure your cloud provider for Azure. Note that the client secret is considered sensitive. To view the value, you can output the values as JSON:

```bash
terraform output -json
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.41.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =3.0.0 |
| <a name="requirement_yba"></a> [yba](#requirement\_yba) | 0.1.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.41.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | =3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.yba_application](https://registry.terraform.io/providers/hashicorp/azuread/2.41.0/docs/resources/application) | resource |
| [azuread_application_password.yba_application_password](https://registry.terraform.io/providers/hashicorp/azuread/2.41.0/docs/resources/application_password) | resource |
| [azuread_service_principal.yba_application_sp](https://registry.terraform.io/providers/hashicorp/azuread/2.41.0/docs/resources/service_principal) | resource |
| [azurerm_linux_virtual_machine.yba_vm](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_marketplace_agreement.yba_vm_agreement](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/marketplace_agreement) | resource |
| [azurerm_network_interface.yba_network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.yba_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.yba_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.yb_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.app_network_contributor_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.app_virtual_machine_contributor_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/role_assignment) | resource |
| [azurerm_subnet.universe_subnets](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/subnet) | resource |
| [azurerm_subnet.yba_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.subnet_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.yb_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/virtual_network) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/2.41.0/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_ssh_key"></a> [admin\_ssh\_key](#input\_admin\_ssh\_key) | The public SSH key for the admin user. | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The username for the SSH admin user. | `string` | n/a | yes |
| <a name="input_customer_tag_value"></a> [customer\_tag\_value](#input\_customer\_tag\_value) | The value for the customer tag for resources. | `string` | n/a | yes |
| <a name="input_department_tag_value"></a> [department\_tag\_value](#input\_department\_tag\_value) | The value for the department tag for resources. | `string` | n/a | yes |
| <a name="input_owner_tag_value"></a> [owner\_tag\_value](#input\_owner\_tag\_value) | The value for the owner tag for resources | `string` | n/a | yes |
| <a name="input_resource_group_region"></a> [resource\_group\_region](#input\_resource\_group\_region) | The Azure region for the resource group and all resrouces | `string` | `"eastus"` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix to use for all resource names. | `string` | n/a | yes |
| <a name="input_sales_region_tag_value"></a> [sales\_region\_tag\_value](#input\_sales\_region\_tag\_value) | The value for the sales region tag for resources | `string` | n/a | yes |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | The path to your private SSH key | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription ID to use for Azure resources | `string` | n/a | yes |
| <a name="input_task_tag_value"></a> [task\_tag\_value](#input\_task\_tag\_value) | The value for the task tag for resources | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The tenant ID from Microsoft Entra ID | `string` | n/a | yes |
| <a name="input_universe_subnets"></a> [universe\_subnets](#input\_universe\_subnets) | Subnets to create for YB universes. Each subnet should have a CIDR range in the vnet\_cidr\_block. The key is made part of the subnet name. | `map(string)` | <pre>{<br>  "1": "10.0.2.0/24",<br>  "2": "10.0.3.0/24",<br>  "3": "10.0.4.0/24"<br>}</pre> | no |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | The size of the VM for YBA. | `string` | `"Standard_D8s_v3"` | no |
| <a name="input_virtual_machine_zone"></a> [virtual\_machine\_zone](#input\_virtual\_machine\_zone) | The zone to create the YBA VM in. | `string` | `"1"` | no |
| <a name="input_vnet_cidr_block"></a> [vnet\_cidr\_block](#input\_vnet\_cidr\_block) | The CIDR block for the virtual network. This should be large enough to hold the YBA and universe subnets. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_yba_admin_email"></a> [yba\_admin\_email](#input\_yba\_admin\_email) | The email address for the YBA admin | `string` | n/a | yes |
| <a name="input_yba_admin_name"></a> [yba\_admin\_name](#input\_yba\_admin\_name) | The username for the YBA admin | `string` | n/a | yes |
| <a name="input_yba_disk_size"></a> [yba\_disk\_size](#input\_yba\_disk\_size) | The size of disk for the YBA VM (in GB) | `string` | `"300"` | no |
| <a name="input_yba_disk_type"></a> [yba\_disk\_type](#input\_yba\_disk\_type) | The type of disk for the YBA VM | `string` | `"Premium_LRS"` | no |
| <a name="input_yba_license_file"></a> [yba\_license\_file](#input\_yba\_license\_file) | The path to the license file for YBA | `string` | n/a | yes |
| <a name="input_yba_nsg_source_cidr"></a> [yba\_nsg\_source\_cidr](#input\_yba\_nsg\_source\_cidr) | The source CIDR block of external access for the YBA network security group. This is probably your IP address. | `string` | n/a | yes |
| <a name="input_yba_settings_file"></a> [yba\_settings\_file](#input\_yba\_settings\_file) | The path to the settings file for YBA | `string` | `""` | no |
| <a name="input_yba_source_image_offer"></a> [yba\_source\_image\_offer](#input\_yba\_source\_image\_offer) | The offer for the YBA VM source image | `string` | n/a | yes |
| <a name="input_yba_source_image_publisher"></a> [yba\_source\_image\_publisher](#input\_yba\_source\_image\_publisher) | The publisher of the YBA VM source image | `string` | n/a | yes |
| <a name="input_yba_source_image_sku"></a> [yba\_source\_image\_sku](#input\_yba\_source\_image\_sku) | The SKU for the YBA VM source image | `string` | n/a | yes |
| <a name="input_yba_source_image_version"></a> [yba\_source\_image\_version](#input\_yba\_source\_image\_version) | The version of the YBA VM source image | `string` | n/a | yes |
| <a name="input_yba_subnet_cidr"></a> [yba\_subnet\_cidr](#input\_yba\_subnet\_cidr) | The CIDR block for the YBA subnet | `string` | `"10.0.1.0/24"` | no |
| <a name="input_yba_version"></a> [yba\_version](#input\_yba\_version) | The version of YBA to install (including build number) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_application_client_id"></a> [provider\_application\_client\_id](#output\_provider\_application\_client\_id) | The application client ID for the Azure cloud provider. |
| <a name="output_provider_application_client_secret"></a> [provider\_application\_client\_secret](#output\_provider\_application\_client\_secret) | The application client secret for the Azure cloud provider. |
| <a name="output_provider_region_subnet_names"></a> [provider\_region\_subnet\_names](#output\_provider\_region\_subnet\_names) | The subnet names to use for the Azure cloud provider's region. |
| <a name="output_provider_region_virtual_network_name"></a> [provider\_region\_virtual\_network\_name](#output\_provider\_region\_virtual\_network\_name) | The virtual network name to use for the Azure cloud provider. |
| <a name="output_provider_resource_group"></a> [provider\_resource\_group](#output\_provider\_resource\_group) | The resource group for the Azure cloud provider. |
| <a name="output_provider_subscription_id"></a> [provider\_subscription\_id](#output\_provider\_subscription\_id) | The subscription id for the Azure cloud provider. |
| <a name="output_provider_tenant_id"></a> [provider\_tenant\_id](#output\_provider\_tenant\_id) | The tenant id for the Azure cloud provider. |
| <a name="output_provider_vnet_id"></a> [provider\_vnet\_id](#output\_provider\_vnet\_id) | The ID of the created vnet for the Azure cloud provider. |
| <a name="output_yba_url"></a> [yba\_url](#output\_yba\_url) | The URL for YBA. |
<!-- END_TF_DOCS -->
