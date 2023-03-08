provider "aws" {
  region = var.region
}

resource "aws_vpc" "yba_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.resource_prefix}-yba-vpc"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

resource "aws_security_group" "yba_sg" {
  name        = "${var.resource_prefix}-yba-sg"
  description = "Allow Yugabyte Platform access"
  vpc_id      = aws_vpc.yba_vpc.id

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
    Name = "${var.resource_prefix}-yba-sg"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

resource "aws_internet_gateway" "yba_igw" {
  vpc_id = aws_vpc.yba_vpc.id
  tags = {
    Name = "${var.resource_prefix}-yba-igw"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

resource "aws_subnet" "yba_public_subnet" {
  vpc_id                  = aws_vpc.yba_vpc.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.public_subnet_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.resource_prefix}-yba-public-subnet-${var.public_subnet_zone}"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

resource "aws_subnet" "yba_private_subnet" {
  vpc_id                  = aws_vpc.yba_vpc.id
  cidr_block              = var.private_subnet_cidr_block
  availability_zone       = var.private_subnet_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.resource_prefix}-yba-private-subnet1-${var.private_subnet_zone}"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

resource "aws_route_table" "yba_public_rt" {
  vpc_id = aws_vpc.yba_vpc.id
  tags = {
    Name = "${var.resource_prefix}-yba-public-route-table"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

resource "aws_route" "yba_public_igw_route" {
  route_table_id         = aws_route_table.yba_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.yba_igw.id
}

resource "aws_route_table_association" "yba_public_rta" {
  count          = "1"
  subnet_id      = aws_subnet.yba_public_subnet.id
  route_table_id = aws_route_table.yba_public_rt.id
}

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

resource "aws_iam_policy_attachment" "yba_policy_attachment" {
  name       = "${var.resource_prefix}-yba-policy-attachment"
  roles      = [aws_iam_role.yba_role.name]
  policy_arn = aws_iam_policy.yba_policy.arn
}

resource "aws_iam_instance_profile" "yba_instance_profile" {
  role = aws_iam_role.yba_role.name
}

data "aws_ami" "yba_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["${var.ami_filter}"]
  }
  owners = ["${var.ami_owner}"]
}

resource "aws_instance" "yba" {
  ami                         = data.aws_ami.yba_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.yba_public_subnet.id
  associate_public_ip_address = true
  key_name                    = var.keypair_name
  iam_instance_profile        = aws_iam_instance_profile.yba_instance_profile.name
  security_groups             = [aws_security_group.yba_sg.id]
  user_data                   = <<-EOL
    #!/bin/bash -xe
    curl -sSL https://get.replicated.com/docker | sudo bash
    EOL
  root_block_device {
    delete_on_termination = true
    volume_size           = var.instance_volume_size
    volume_type           = var.instance_volume_type
  }
  tags = {
    Name = "${var.resource_prefix}-yba"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}
