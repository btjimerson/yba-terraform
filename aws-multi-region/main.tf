terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Set up Yugabyte Platform
module "yb_platform" {
  source                               = "./modules/yba"
  resource_prefix                      = var.resource_prefix
  department_tag_value                 = var.department_tag_value
  task_tag_value                       = var.task_tag_value
  owner_tag_value                      = var.owner_tag_value
  customer_tag_value                   = var.customer_tag_value
  sales_region_tag_value               = var.sales_region_tag_value
  region                               = var.yba_region
  security_groups_external_source_cidr = var.yb_security_groups_external_source_cidr
  vpc_cidr_block                       = var.yba_vpc_cidr_block
  public_subnet_zone                   = var.yba_public_subnet_zone
  public_subnet_cidr_block             = var.yba_public_subnet_cidr_block
  private_subnet_zone                  = var.yba_private_subnet_zone
  private_subnet_cidr_block            = var.yba_private_subnet_cidr_block
  ami_filter                           = var.yba_ami_filter
  ami_owner                            = var.yba_ami_owner
  instance_type                        = var.yba_instance_type
  instance_volume_size                 = var.yba_instance_volume_size
  instance_volume_type                 = var.yba_instance_volume_type
  keypair_name                         = var.yba_keypair_name
}

# VPC for the 1st region
module "yb_vpc_region_1" {
  source                               = "./modules/yba"
  resource_prefix                      = var.resource_prefix
  department_tag_value                 = var.department_tag_value
  task_tag_value                       = var.task_tag_value
  owner_tag_value                      = var.owner_tag_value
  customer_tag_value                   = var.customer_tag_value
  sales_region_tag_value               = var.sales_region_tag_value
  region                               = var.yb_region_1_region
  security_groups_external_source_cidr = var.yb_security_groups_external_source_cidr
  security_groups_yba_cidr             = var.yba_vpc_cidr_block
  security_groups_peer_cidrs           = [var.yb_region_2_private_subnet_cidr_block, var.yb_region_3_private_subnet_cidr_block]
  vpc_cidr_block                       = var.yb_region_1_vpc_cidr_block
  public_subnet_zone                   = var.yb_region_1_public_subnet_zone
  public_subnet_cidr_block             = var.yb_region_1_public_subnet_cidr_block
  private_subnet_zone                  = var.yb_region_1_private_subnet_zone
  private_subnet_cidr_block            = var.yb_region_1_private_subnet_cidr_block
}

# VPC for the 2nd region
module "yb_vpc_region_2" {
  source                               = "./modules/yba"
  resource_prefix                      = var.resource_prefix
  department_tag_value                 = var.department_tag_value
  task_tag_value                       = var.task_tag_value
  owner_tag_value                      = var.owner_tag_value
  customer_tag_value                   = var.customer_tag_value
  sales_region_tag_value               = var.sales_region_tag_value
  region                               = var.yb_region_2_region
  security_groups_external_source_cidr = var.yb_security_groups_external_source_cidr
  security_groups_yba_cidr             = var.yba_vpc_cidr_block
  security_groups_peer_cidrs           = [var.yb_region_1_private_subnet_cidr_block, var.yb_region_3_private_subnet_cidr_block]
  vpc_cidr_block                       = var.yb_region_2_vpc_cidr_block
  public_subnet_zone                   = var.yb_region_2_public_subnet_zone
  public_subnet_cidr_block             = var.yb_region_2_public_subnet_cidr_block
  private_subnet_zone                  = var.yb_region_2_private_subnet_zone
  private_subnet_cidr_block            = var.yb_region_2_private_subnet_cidr_block
}

# VPC for the 3rd region
module "yb_vpc_region_3" {
  source                               = "./modules/yba"
  resource_prefix                      = var.resource_prefix
  department_tag_value                 = var.department_tag_value
  task_tag_value                       = var.task_tag_value
  owner_tag_value                      = var.owner_tag_value
  customer_tag_value                   = var.customer_tag_value
  sales_region_tag_value               = var.sales_region_tag_value
  region                               = var.yb_region_3_region
  security_groups_external_source_cidr = var.yb_security_groups_external_source_cidr
  security_groups_yba_cidr             = var.yba_vpc_cidr_block
  security_groups_peer_cidrs           = [var.yb_region_1_private_subnet_cidr_block, var.yb_region_2_private_subnet_cidr_block]
  vpc_cidr_block                       = var.yb_region_3_vpc_cidr_block
  public_subnet_zone                   = var.yb_region_3_public_subnet_zone
  public_subnet_cidr_block             = var.yb_region_3_public_subnet_cidr_block
  private_subnet_zone                  = var.yb_region_3_private_subnet_zone
  private_subnet_cidr_block            = var.yb_region_3_private_subnet_cidr_block
}

# Peering connection between Yugabyte Platform and the 1st region
module "yb_pcx_yba_region_1" {
  source                        = "./modules/yba-pcx"
  resource_prefix               = var.resource_prefix
  department_tag_value          = var.department_tag_value
  task_tag_value                = var.task_tag_value
  owner_tag_value               = var.owner_tag_value
  customer_tag_value            = var.customer_tag_value
  sales_region_tag_value        = var.sales_region_tag_value
  main_region                   = var.yba_region
  main_vpc_id                   = module.yb_platform.vpc_id
  main_public_subnet_cidr_block = var.yba_public_subnet_cidr_block
  main_public_route_table_id    = module.yb_platform.public_route_table_id
  peer_region                   = var.yb_region_1_region
  peer_vpc_id                   = module.yb_vpc_region_1.vpc_id
  peer_public_subnet_cidr_block = var.yb_region_1_public_subnet_cidr_block
  peer_public_route_table_id    = module.yb_vpc_region_1.public_route_table_id
}

# Peering connection between Yugabyte Platform and the 2nd region
module "yb_pcx_yba_region_2" {
  source                        = "./modules/yba-pcx"
  resource_prefix               = var.resource_prefix
  department_tag_value          = var.department_tag_value
  task_tag_value                = var.task_tag_value
  owner_tag_value               = var.owner_tag_value
  customer_tag_value            = var.customer_tag_value
  sales_region_tag_value        = var.sales_region_tag_value
  main_region                   = var.yba_region
  main_vpc_id                   = module.yb_platform.vpc_id
  main_public_subnet_cidr_block = var.yba_public_subnet_cidr_block
  main_public_route_table_id    = module.yb_platform.public_route_table_id
  peer_region                   = var.yb_region_2_region
  peer_vpc_id                   = module.yb_vpc_region_2.vpc_id
  peer_public_subnet_cidr_block = var.yb_region_2_public_subnet_cidr_block
  peer_public_route_table_id    = module.yb_vpc_region_2.public_route_table_id
}

# Peering connection between Yugabyte Platform and the 3rd region
module "yb_pcx_yba_region_3" {
  source                        = "./modules/yba-pcx"
  resource_prefix               = var.resource_prefix
  department_tag_value          = var.department_tag_value
  task_tag_value                = var.task_tag_value
  owner_tag_value               = var.owner_tag_value
  customer_tag_value            = var.customer_tag_value
  sales_region_tag_value        = var.sales_region_tag_value
  main_region                   = var.yba_region
  main_vpc_id                   = module.yb_platform.vpc_id
  main_public_subnet_cidr_block = var.yba_public_subnet_cidr_block
  main_public_route_table_id    = module.yb_platform.public_route_table_id
  peer_region                   = var.yb_region_3_region
  peer_vpc_id                   = module.yb_vpc_region_3.vpc_id
  peer_public_subnet_cidr_block = var.yb_region_3_public_subnet_cidr_block
  peer_public_route_table_id    = module.yb_vpc_region_3.public_route_table_id
}

# Peering connection between the 1st region and the 2nd region
module "yb_pcx_region_1_region_2" {
  source                        = "./modules/yba-pcx"
  resource_prefix               = var.resource_prefix
  department_tag_value          = var.department_tag_value
  task_tag_value                = var.task_tag_value
  owner_tag_value               = var.owner_tag_value
  customer_tag_value            = var.customer_tag_value
  sales_region_tag_value        = var.sales_region_tag_value
  main_region                   = var.yb_region_1_region
  main_vpc_id                   = module.yb_vpc_region_1.vpc_id
  main_public_subnet_cidr_block = var.yb_region_1_public_subnet_cidr_block
  main_public_route_table_id    = module.yb_vpc_region_1.public_route_table_id
  peer_region                   = var.yb_region_2_region
  peer_vpc_id                   = module.yb_vpc_region_2.vpc_id
  peer_public_subnet_cidr_block = var.yb_region_2_public_subnet_cidr_block
  peer_public_route_table_id    = module.yb_vpc_region_2.public_route_table_id
}

# Peering connection between the 1st region and the 3rd region
module "yb_pcx_region_1_region_3" {
  source                        = "./modules/yba-pcx"
  resource_prefix               = var.resource_prefix
  department_tag_value          = var.department_tag_value
  task_tag_value                = var.task_tag_value
  owner_tag_value               = var.owner_tag_value
  customer_tag_value            = var.customer_tag_value
  sales_region_tag_value        = var.sales_region_tag_value
  main_region                   = var.yb_region_1_region
  main_vpc_id                   = module.yb_vpc_region_1.vpc_id
  main_public_subnet_cidr_block = var.yb_region_1_public_subnet_cidr_block
  main_public_route_table_id    = module.yb_vpc_region_1.public_route_table_id
  peer_region                   = var.yb_region_3_region
  peer_vpc_id                   = module.yb_vpc_region_3.vpc_id
  peer_public_subnet_cidr_block = var.yb_region_3_public_subnet_cidr_block
  peer_public_route_table_id    = module.yb_vpc_region_3.public_route_table_id
}

# Peering connection between the 2nd region and the 3rd region
module "yb_pcx_region_2_region_3" {
  source                        = "./modules/yba-pcx"
  resource_prefix               = var.resource_prefix
  department_tag_value          = var.department_tag_value
  task_tag_value                = var.task_tag_value
  owner_tag_value               = var.owner_tag_value
  customer_tag_value            = var.customer_tag_value
  sales_region_tag_value        = var.sales_region_tag_value
  main_region                   = var.yb_region_2_region
  main_vpc_id                   = module.yb_vpc_region_2.vpc_id
  main_public_subnet_cidr_block = var.yb_region_2_public_subnet_cidr_block
  main_public_route_table_id    = module.yb_vpc_region_2.public_route_table_id
  peer_region                   = var.yb_region_3_region
  peer_vpc_id                   = module.yb_vpc_region_3.vpc_id
  peer_public_subnet_cidr_block = var.yb_region_3_public_subnet_cidr_block
  peer_public_route_table_id    = module.yb_vpc_region_3.public_route_table_id
}