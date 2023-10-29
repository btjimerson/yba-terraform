terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.0"
      configuration_aliases = [aws.local, aws.peer]
    }
  }
}

// Create peering connection between the local VPC and the peer VPC
resource "aws_vpc_peering_connection" "local_to_peer_pcx" {
  provider = aws.local

  peer_region = var.peer_region
  peer_vpc_id = var.peer_vpc_id
  vpc_id      = var.local_vpc_id
  tags = {
    "Name" = "${var.resource_prefix}-pcx"
  }
}

// Have the peer VPC accept the peering connection
resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  provider = aws.peer

  vpc_peering_connection_id = aws_vpc_peering_connection.local_to_peer_pcx.id
  auto_accept               = true
}

// Create a route from the local VPC to the peer VPC
resource "aws_route" "route_to_peer" {
  provider = aws.local

  route_table_id            = var.local_route_table_id
  destination_cidr_block    = var.peer_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.local_to_peer_pcx.id
}

// Create a route from the peer VPC to the local VPC
resource "aws_route" "route_to_local" {
  provider = aws.peer

  route_table_id            = var.peer_route_table_id
  destination_cidr_block    = var.local_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.local_to_peer_pcx.id
}
