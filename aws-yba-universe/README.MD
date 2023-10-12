# YugabyteDB Anywhere Cloud Provider and Universe for Azure

## Introduction

This repository contains a Terraform configuration an Azure cloud provider and universe with an existing YBA installation.  This configuration creates:

* An Azure cloud provider 
    * A single region in the provider
    * 1 or more zones for the region
* A universe based on the Azure cloud provider

## Prerequisites

You should have the following prior to applying this configuration

* A YugabyteDB Anywhere installation
* Access to an available Azure region
* A resource group for the universe
* A client id and secret to use to install the universe
* The subscription and tenant IDs for Azure

## Set up environment variables

The following environment variables should be set prior to applying the configuration

* `AZURE_CLIENT_ID` - The application client ID to use
* `AZURE_CLIENT_SECRET` - The application client secret to use
* `AZURE_RG` - The resource group
* `AZURE_SUBSCRIPTION_ID` - Your subscription ID
* `AZURE_TENANT_ID` - Your tenant ID

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

```