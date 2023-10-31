terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

# Get the kubeconfig
resource "null_resource" "cluster_kubeconfig" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.gke_cluster_name} --region ${var.gcp_region} --project ${var.gcp_project_id}"
  }
}

# Namespace for YBA
resource "kubernetes_namespace" "yba_namespace" {
  metadata {
    name = var.yba_namespace
  }
}

# Pull secret for YBA
resource "kubernetes_secret" "yugabyte_pull_secret" {
  depends_on = [kubernetes_namespace.yba_namespace]
  metadata {
    name      = "yugabyte-k8s-pull-secret"
    namespace = var.yba_namespace
  }
  data = {
    ".dockerconfigjson" = var.yba_pull_secret
  }
  type = "kubernetes.io/dockerconfigjson"
}

# Install YBA helm chart
resource "helm_release" "yba" {
  depends_on = [
    kubernetes_namespace.yba_namespace,
    kubernetes_secret.yugabyte_pull_secret
  ]
  name       = "yugaware"
  namespace  = var.yba_namespace
  version    = var.yba_version
  repository = "https://charts.yugabyte.com"
  chart      = "yugaware"
  set {
    name  = "istioCompatibility.enabled"
    value = true
  }
  set {
    name  = "tls.enabled"
    value = var.enable_yba_tls
  }
}

// Wait for 60 seconds for the LB IP address to be created
resource "time_sleep" "wait_for_60_seconds" {
  depends_on      = [helm_release.yba]
  create_duration = "60s"
}

// Get the IP address for YBA
data "external" "yba_hostname" {
  depends_on = [time_sleep.wait_for_60_seconds]
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(kubectl get svc yugaware-yugaware-ui -n ${var.yba_namespace} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')\" '{$content}'"
  ]
}

# Create the universe management namespace
resource "kubernetes_namespace" "universe_management_namespace" {
  metadata {
    name = var.universe_management_namespace
  }
}

# Create the universe management service account
resource "kubernetes_service_account" "universe_management_sa" {
  metadata {
    name      = var.universe_management_sa
    namespace = var.universe_management_namespace
  }
}

# Create the universe management cluster role
resource "kubernetes_cluster_role" "universe_management_cluster_role" {
  metadata {
    name = var.universe_management_cluster_role
  }
  rule {
    api_groups = [""]
    resources = [
      "nodes",
      "nodes/proxy",
      "services",
      "endpoints",
      "pods"
    ]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
}

# Create the universe management role binding
resource "kubernetes_cluster_role_binding" "universe_management_cluster_role_binding" {
  depends_on = [
    kubernetes_service_account.universe_management_sa,
    kubernetes_cluster_role.universe_management_cluster_role
  ]
  metadata {
    name = var.universe_management_cluster_role_binding
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.universe_management_cluster_role
  }
  subject {
    namespace = var.universe_management_namespace
    kind      = "ServiceAccount"
    name      = var.universe_management_sa
  }

}

# Create the universe management sa token
resource "kubernetes_secret" "universe_management_sa_token" {
  depends_on = [kubernetes_service_account.universe_management_sa]
  metadata {
    name      = var.universe_management_sa
    namespace = var.universe_management_namespace
    annotations = {
      "kubernetes.io/service-account.name" = var.universe_management_sa
    }
  }
  type = "kubernetes.io/service-account-token"
}