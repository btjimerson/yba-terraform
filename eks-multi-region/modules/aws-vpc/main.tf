terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

// Get the current region
data "aws_region" "current" {}

// Get the available availability zones
data "aws_availability_zones" "available_azs" {
  state = "available"
}

# Create a VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    "Name" = "${var.resource_prefix}-${data.aws_region.current.name}-vpc"
  }
}

# Create the subnets for the VPC
resource "aws_subnet" "subnets" {
  count = var.number_of_subnets

  availability_zone       = data.aws_availability_zones.available_azs.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index)
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.resource_prefix}-${data.aws_region.current.name}-subnet-${count.index}"
  }
  vpc_id = aws_vpc.vpc.id
}

# Create an internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.resource_prefix}-${data.aws_region.current.name}-igw"
  }
}

# Create a route table for public subnets
resource "aws_route_table" "public_route_table" {
  tags = {
    "Name" = "${var.resource_prefix}-${data.aws_region.current.name}-route-table"
  }
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

# Associate each of the public subnets with the internet route table
resource "aws_route_table_association" "public_subnets_to_route_table" {
  count          = length(aws_subnet.subnets)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

