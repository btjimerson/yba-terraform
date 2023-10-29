output "eks_cluster_ca_data" {
  description = "The certificate authority data of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}
output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

