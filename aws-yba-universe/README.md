# YugabyteDB Anywhere Cloud Provider and Universe for AWS

## Introduction

This repository contains a Terraform configuration for an AWS cloud provider and universe with an existing YBA installation.  This configuration creates:

* An AWS cloud provider 
    * A single region in the provider
    * 1 or more zones for the region
* A universe based on the AWS cloud provider

## Prerequisites

You should have the following prior to applying this configuration

* A YugabyteDB Anywhere installation
* An API token for YBA
* An AWS VPC with one or more subnets
* A security group for the universe

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
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```