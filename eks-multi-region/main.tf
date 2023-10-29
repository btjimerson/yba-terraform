// Configure AWS provider for different regions
provider "aws" {
  alias  = "region_1"
  region = var.vpc_1.region

  default_tags {
    tags = {
      "yb_dept"        = var.department_tag_value
      "yb_task"        = var.task_tag_value
      "yb_owner"       = var.owner_tag_value
      "yb_customer"    = var.customer_tag_value
      "yb_salesregion" = var.sales_region_tag_value
    }
  }
}

provider "aws" {
  alias  = "region_2"
  region = var.vpc_2.region

  default_tags {
    tags = {
      "yb_dept"        = var.department_tag_value
      "yb_task"        = var.task_tag_value
      "yb_owner"       = var.owner_tag_value
      "yb_customer"    = var.customer_tag_value
      "yb_salesregion" = var.sales_region_tag_value
    }
  }
}

provider "kubernetes" {
  alias                  = "eks_cluster_1"
  host                   = module.aws_eks_cluster_1.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.aws_eks_cluster_1.eks_cluster_ca_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.aws_eks_cluster_1.eks_cluster_name]
  }
}

provider "helm" {
  alias = "eks_cluster_1_helm"
  kubernetes {
    host                   = module.aws_eks_cluster_1.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.aws_eks_cluster_1.eks_cluster_ca_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.aws_eks_cluster_1.eks_cluster_name]
    }
  }
}

provider "kubernetes" {
  alias                  = "eks_cluster_2"
  host                   = module.aws_eks_cluster_2.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.aws_eks_cluster_2.eks_cluster_ca_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.aws_eks_cluster_2.eks_cluster_name]
  }
}

provider "helm" {
  alias = "eks_cluster_2_helm"
  kubernetes {
    host                   = module.aws_eks_cluster_2.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.aws_eks_cluster_2.eks_cluster_ca_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.aws_eks_cluster_2.eks_cluster_name]
    }
  }
}

# Create the first vpc
module "aws_vpc_1" {
  source = "./modules/aws-vpc"
  providers = {
    aws = aws.region_1
  }

  number_of_subnets = var.number_of_subnets
  resource_prefix   = var.resource_prefix
  vpc_cidr_block    = var.vpc_1.cidr_block
}

# Create the second vpc
module "aws_vpc_2" {
  source = "./modules/aws-vpc"
  providers = {
    aws = aws.region_2
  }

  number_of_subnets = var.number_of_subnets
  resource_prefix   = var.resource_prefix
  vpc_cidr_block    = var.vpc_2.cidr_block
}

# Create a peering connection between the 2 VPCs
module "aws_peering_connection" {
  source     = "./modules/aws-peering-connection"
  depends_on = [module.aws_vpc_1, module.aws_vpc_2]
  providers = {
    aws.local = aws.region_1
    aws.peer  = aws.region_2
  }

  local_region         = var.vpc_1.region
  local_route_table_id = module.aws_vpc_1.route_table_id
  local_vpc_cidr_block = var.vpc_1.cidr_block
  local_vpc_id         = module.aws_vpc_1.vpc_id
  peer_region          = var.vpc_2.region
  peer_route_table_id  = module.aws_vpc_2.route_table_id
  peer_vpc_cidr_block  = var.vpc_2.cidr_block
  peer_vpc_id          = module.aws_vpc_2.vpc_id
  resource_prefix      = var.resource_prefix
}

# Create the 1st EKS cluster
module "aws_eks_cluster_1" {
  source     = "./modules/aws-eks"
  depends_on = [module.aws_vpc_1]
  providers = {
    aws = aws.region_1
  }

  eks_kubernetes_version   = var.eks_kubernetes_version
  eks_subnet_ids           = module.aws_vpc_1.subnet_ids
  node_group_disk_size     = var.node_group_disk_size
  node_group_instance_type = var.node_group_instance_type
  resource_prefix          = var.resource_prefix
}

# Create the 2nd EKS cluster
module "aws_eks_cluster_2" {
  source     = "./modules/aws-eks"
  depends_on = [module.aws_vpc_2]
  providers = {
    aws = aws.region_2
  }

  eks_kubernetes_version   = var.eks_kubernetes_version
  eks_subnet_ids           = module.aws_vpc_2.subnet_ids
  node_group_disk_size     = var.node_group_disk_size
  node_group_instance_type = var.node_group_instance_type
  resource_prefix          = var.resource_prefix
}

# Install YBA
//module "yba" {
//  source     = "./modules/yba"
//  depends_on = [module.aws_eks_cluster_1]
// providers = {
//   kubernetes = kubernetes.eks_cluster_1
//   helm       = helm.eks_cluster_1_helm
// }

// universe_management_cluster_role         = var.universe_management_cluster_role
// universe_management_cluster_role_binding = var.universe_management_cluster_role_binding
// universe_management_namespace            = var.universe_management_namespace
// universe_management_sa                   = var.universe_management_sa
// yba_namespace                            = var.yba_namespace
// yba_pull_secret                          = var.yba_pull_secret
// yba_role                                 = var.yba_role
// yba_role_binding                         = var.yba_role_binding
// yba_sa                                   = var.yba_sa
// yba_version                              = var.yba_version
//}

