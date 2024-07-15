provider "aws" {
  region = var.region
}

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

resource "aws_security_group" "yb_sg" {
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
    description = "node-agent"
    from_port   = 9070
    protocol    = "tcp"
    to_port     = 9070
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

resource "aws_subnet" "yb_public_subnet" {
  vpc_id                  = aws_vpc.yb_vpc.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.public_subnet_zone
  map_public_ip_on_launch = true

  tags = {
    Name             = "${var.resource_prefix}-yb-public-subnet-${var.public_subnet_zone}"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

resource "aws_subnet" "yb_private_subnet" {
  vpc_id                  = aws_vpc.yb_vpc.id
  cidr_block              = var.private_subnet_cidr_block
  availability_zone       = var.private_subnet_zone
  map_public_ip_on_launch = false

  tags = {
    Name             = "${var.resource_prefix}-yb-private-subnet1-${var.private_subnet_zone}"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

resource "aws_route_table" "yb_public_rt" {
  vpc_id = aws_vpc.yb_vpc.id
  tags = {
    Name             = "${var.resource_prefix}-yb-public-route-table"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

resource "aws_route" "yb_public_igw_route" {
  route_table_id         = aws_route_table.yb_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.yb_igw.id
}

resource "aws_route_table_association" "yb_public_rta" {
  count          = "1"
  subnet_id      = aws_subnet.yb_public_subnet.id
  route_table_id = aws_route_table.yb_public_rt.id
}
