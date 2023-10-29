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

// Get the IAM policy for EKS
data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

// Create an IAM role for the EKS cluster policy
resource "aws_iam_role" "eks_cluster_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

// Attach the EKS cluster policy to the EKS role
resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_iam_role.name
}

// Create the EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  depends_on = [aws_iam_role_policy_attachment.eks_policy_attachment]

  name     = "${var.resource_prefix}-${data.aws_region.current.name}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_iam_role.arn
  version  = var.eks_kubernetes_version
  vpc_config {
    subnet_ids = var.eks_subnet_ids
  }
}

// Create an IAM role for the EKS node group policy
resource "aws_iam_role" "eks_node_group_iam_role" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

// Attach the EKS worker node policy to the node group role
resource "aws_iam_role_policy_attachment" "worker_node_policy_attachement" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_iam_role.name
}

// Attach the ECR policy to the node group role
resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_iam_role.name
}

// Attach the CNI policy to the node group role 
resource "aws_iam_role_policy_attachment" "cni_policy_attachement" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_iam_role.name
}

// Create the node group for the EKS cluster
resource "aws_eks_node_group" "eks_node_group" {
  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy_attachement,
    aws_iam_role_policy_attachment.ecr_policy_attachment,
    aws_iam_role_policy_attachment.cni_policy_attachement
  ]

  cluster_name           = aws_eks_cluster.eks_cluster.name
  disk_size              = var.node_group_disk_size
  instance_types         = [var.node_group_instance_type]
  node_group_name_prefix = "${var.resource_prefix}-${data.aws_region.current.name}"
  node_role_arn          = aws_iam_role.eks_node_group_iam_role.arn
  scaling_config {
    desired_size = length(var.eks_subnet_ids)
    min_size     = length(var.eks_subnet_ids)
    max_size     = length(var.eks_subnet_ids) * 2
  }
  subnet_ids = var.eks_subnet_ids
}
