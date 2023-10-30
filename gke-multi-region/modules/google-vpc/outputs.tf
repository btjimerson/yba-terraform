output "vpc_self_link" {
  description = "The self link to the VPC created"
  value       = google_compute_network.vpc.self_link
}
output "subnets_self_link" {
  description = "The self link to the subnets created"
  value       = google_compute_subnetwork.subnets.*.self_link
}
