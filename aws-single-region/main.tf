terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Create a VPC
resource "aws_vpc" "yb_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name             = "${var.resource_prefix}-${var.region}-yb-vpc"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

# Create the private subnets
resource "aws_subnet" "yb_private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.yb_vpc.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["zone"]

  tags = {
    Name             = "${var.resource_prefix}-yb-private-subnet-${each.value["zone"]}"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

# Create the public subnets
resource "aws_subnet" "yb_public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.yb_vpc.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["zone"]
  map_public_ip_on_launch = true

  tags = {
    Name             = "${var.resource_prefix}-yb-public-subnet-${each.value["zone"]}"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "yb_igw" {
  vpc_id = aws_vpc.yb_vpc.id
  tags = {
    Name             = "${var.resource_prefix}-${var.region}-yb-igw"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

# Create a route table for public subnets
resource "aws_route_table" "yb_public_route_table" {
  vpc_id = aws_vpc.yb_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.yb_igw.id
  }
  tags = {
    Name             = "${var.resource_prefix}-yb-public-route-table}"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

# Associate each of the public subnets with the internet route table
resource "aws_route_table_association" "yb_public_subnets_to_route_table" {
  for_each       = aws_subnet.yb_public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.yb_public_route_table.id
}

# Security group for universes
resource "aws_security_group" "universe_sg" {
  name        = "${var.resource_prefix}-${var.region}-yb-sg"
  description = "Allow YB access"
  vpc_id      = aws_vpc.yb_vpc.id
  depends_on  = [aws_vpc.yb_vpc]

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "master-http"
    from_port   = 7000
    protocol    = "tcp"
    to_port     = 7000
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "master-rpc"
    from_port   = 7100
    protocol    = "tcp"
    to_port     = 7100
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "tserver-http"
    from_port   = 9000
    protocol    = "tcp"
    to_port     = 9000
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "tserver-rpc"
    from_port   = 9100
    protocol    = "tcp"
    to_port     = 9100
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "controller"
    from_port   = 18018
    protocol    = "tcp"
    to_port     = 18018
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "yedis-api"
    from_port   = 11000
    protocol    = "tcp"
    to_port     = 11000
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ycql-api"
    from_port   = 12000
    protocol    = "tcp"
    to_port     = 12000
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ysql-api"
    from_port   = 13000
    protocol    = "tcp"
    to_port     = 13000
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "prometheus-metrics"
    from_port   = 9300
    protocol    = "tcp"
    to_port     = 9300
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ycql"
    from_port   = 9042
    protocol    = "tcp"
    to_port     = 9042
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ysql"
    from_port   = 5433
    protocol    = "tcp"
    to_port     = 5433
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "yedis"
    from_port   = 6379
    protocol    = "tcp"
    to_port     = 6379
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "custom-ssh"
    from_port   = 54422
    protocol    = "tcp"
    to_port     = 54422
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "all-egress"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name             = "${var.resource_prefix}-${var.region}-yb-sg"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

# Security group for access to YBA
resource "aws_security_group" "yba_sg" {
  name        = "${var.resource_prefix}-yba-sg"
  description = "Allow Yugabyte Platform access"
  vpc_id      = aws_vpc.yb_vpc.id

  ingress {
    cidr_blocks = [var.security_groups_external_source_cidr]
    description = "yba-ui"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    cidr_blocks = [var.security_groups_external_source_cidr]
    description = "replicated-ui"
    from_port   = 8800
    protocol    = "tcp"
    to_port     = 8800
  }
  ingress {
    cidr_blocks = [var.security_groups_external_source_cidr]
    description = "ssh"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "all-egress"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name             = "${var.resource_prefix}-yba-sg"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

# Create an IAM policy for YBA
resource "aws_iam_policy" "yba_policy" {
  name        = "${var.resource_prefix}-yba-policy"
  path        = "/"
  description = "Allows the Yugabyte Platform EC2 instance to create resources"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:ImportVolume",
          "ec2:ModifyVolumeAttribute",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceAttribute",
          "ec2:CreateKeyPair",
          "ec2:DescribeVolumesModifications",
          "ec2:DeleteVolume",
          "ec2:DescribeVolumeStatus",
          "ec2:StartInstances",
          "ec2:DescribeAvailabilityZones",
          "ec2:CreateSecurityGroup",
          "ec2:DescribeVolumes",
          "ec2:ModifyInstanceAttribute",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeInstanceStatus",
          "ec2:DetachVolume",
          "ec2:ModifyVolume",
          "ec2:TerminateInstances",
          "ec2:AssignIpv6Addresses",
          "ec2:ImportKeyPair",
          "ec2:DescribeTags",
          "ec2:CreateTags",
          "ec2:RunInstances",
          "ec2:AssignPrivateIpAddresses",
          "ec2:StopInstances",
          "ec2:AllocateAddress",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateVolume",
          "ec2:EnableVolumeIO",
          "ec2:DescribeImages",
          "ec2:DescribeVpcs",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSubnets",
          "ec2:DeleteKeyPair",
          "ec2:DescribeVpcPeeringConnections",
          "ec2:DescribeRouteTables",
          "ec2:DescribeInternetGateways",
          "ec2:AssociateRouteTable",
          "ec2:AttachInternetGateway",
          "ec2:CreateInternetGateway",
          "ec2:CreateRoute",
          "ec2:CreateSubnet",
          "ec2:CreateVpc",
          "ec2:CreateVpcPeeringConnection",
          "ec2:AcceptVpcPeeringConnection",
          "ec2:DisassociateRouteTable",
          "ec2:ModifyVpcAttribute",
          "ec2:GetConsoleOutput",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeInstanceTypes",
          "ec2:CreateVpc",
          "ec2:CreateSubnet",
          "ec2:DescribeAvailabilityZones",
          "ec2:CreateRouteTable",
          "ec2:CreateRoute",
          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:AssociateRouteTable",
          "ec2:ModifyVpcAttribute"
        ]
      }
    ]
  })
}

# Create an IAM role for YBA
resource "aws_iam_role" "yba_role" {
  name = "${var.resource_prefix}-yba-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the YBA IAM policy to the IAM role
resource "aws_iam_policy_attachment" "yba_policy_attachment" {
  name       = "${var.resource_prefix}-yba-policy-attachment"
  roles      = [aws_iam_role.yba_role.name]
  policy_arn = aws_iam_policy.yba_policy.arn
}

# Create an IAM instance profile for the YBA EC2 instance
resource "aws_iam_instance_profile" "yba_instance_profile" {
  role = aws_iam_role.yba_role.name
}

# Find an AMI to use for the YBA instance
data "aws_ami" "yba_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["${var.yba_ami_filter}"]
  }
  owners = ["${var.yba_ami_owner}"]
}

# Create the YBA instace
resource "aws_instance" "yba" {
  ami                         = data.aws_ami.yba_ami.id
  instance_type               = var.yba_instance_type
  subnet_id                   = aws_subnet.yb_public_subnets[keys(var.public_subnets)[0]].id
  associate_public_ip_address = true
  key_name                    = var.yba_keypair_name
  iam_instance_profile        = aws_iam_instance_profile.yba_instance_profile.name
  security_groups             = [aws_security_group.yba_sg.id]
  user_data                   = <<-EOL
    #!/bin/bash -xe
    curl -sSL https://get.replicated.com/docker | sudo bash
    EOL
  root_block_device {
    delete_on_termination = true
    volume_size           = var.yba_instance_volume_size
    volume_type           = var.yba_instance_volume_type
  }
  tags = {
    Name             = "${var.resource_prefix}-yba"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

