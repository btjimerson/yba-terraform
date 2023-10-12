terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    yba = {
      source  = "yugabyte/yba"
      version = "0.1.8"
    }
  }
}

# Unauthenticated YBA provider
provider "yba" {
  alias = "unauthenticated"
  host  = aws_instance.yba.public_ip
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
    description = "yedis-http"
    from_port   = 11000
    protocol    = "tcp"
    to_port     = 11000
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ycql-http"
    from_port   = 12000
    protocol    = "tcp"
    to_port     = 12000
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ysql-http"
    from_port   = 13000
    protocol    = "tcp"
    to_port     = 13000
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "node-exporter"
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
    description = "yba-ui-http"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    cidr_blocks = [var.security_groups_external_source_cidr]
    description = "yba-ui-https"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
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
    name   = "image-id"
    values = ["${var.yba_ami_id}"]
  }
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
    curl -sSL https://downloads.yugabyte.com/get_clients.sh | bash
    sudo apt-get update
    sudo apt-get install -y python3.8
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
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

# Wait 60 seconds for python to finish installing
resource "time_sleep" "wait_2_minutes" {
  depends_on      = [aws_instance.yba]
  create_duration = "120s"
}

# YBA Installer
resource "yba_installer" "yba" {
  depends_on                = [time_sleep.wait_2_minutes]
  provider                  = yba.unauthenticated
  ssh_host_ip               = aws_instance.yba.public_ip
  ssh_user                  = var.ssh_user
  yba_license_file          = var.yba_license_file
  application_settings_file = var.yba_settings_file == "" ? null : var.yba_settings_file
  yba_version               = var.yba_version
  ssh_private_key_file_path = var.ssh_private_key_path
}

# Admin user for YBA
# Make sure YB_CUSTOMER_PASSWORD environment variable is set
resource "yba_customer_resource" "yba_admin" {
  depends_on = [yba_installer.yba]
  provider   = yba.unauthenticated
  code       = "admin"
  email      = var.yba_admin_email
  name       = var.yba_admin_name
}

