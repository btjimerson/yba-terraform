# YugabyteDB Anywhere Azure Multi Region Configuration

## Introduction

This repository contains a Terraform configuration to create a multi-region Azure environment with YugabyteDB Anywhere.  By default, this configuration creates:

* A resource group in for each region.
* A virtual network in the resource group.
* A subnet in the virtual network for YBA.
* A security group to allow the required traffic to YBA.
* A public IP address for the YBA VM.
* One or more subnets in the virtual network for YB universes.
* A virtual machine with YugabyteDB Anywhere installed. This VM will also have `ysqlsh` and `ycqlsh` installed in the user's home directory. You can SSH into this VM and then access universe nodes from here.
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

You can open the output for `yba_ip_address` in a browser and create an Administrator user as usual.

You can use the outputs that start with `provider_` to configure your cloud provider for Azure. Note that the client secret is considered sensitive. To view the value, you can output the values as JSON:

```bash
terraform output -json
```

