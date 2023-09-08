provider "aws" {
  region = var.main_region
  alias  = "main"
}

provider "aws" {
  region = var.peer_region
  alias  = "peer"
}

resource "aws_vpc_peering_connection" "main_to_peer" {
  provider    = aws.main
  peer_region = var.peer_region
  vpc_id      = var.main_vpc_id
  peer_vpc_id = var.peer_vpc_id
  tags = {
    "Name"           = "${var.resource_prefix}-${var.main_region}-${var.peer_region}-pcx"
    "yb_dept"        = var.department_tag_value
    "yb_task"        = var.task_tag_value
    "yb_owner"       = var.owner_tag_value
    "yb_customer"    = var.customer_tag_value
    "yb_salesregion" = var.sales_region_tag_value
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.main_to_peer.id
  auto_accept               = true
}

resource "aws_route" "peer_route" {
  provider                  = aws.main
  route_table_id            = var.main_public_route_table_id
  destination_cidr_block    = var.peer_public_subnet_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main_to_peer.id
}

resource "aws_route" "main_route" {
  provider                  = aws.peer
  route_table_id            = var.peer_public_route_table_id
  destination_cidr_block    = var.main_public_subnet_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main_to_peer.id
}