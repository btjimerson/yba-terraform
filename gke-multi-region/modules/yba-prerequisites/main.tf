terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

# Namespace for Istio
resource "kubernetes_namespace" "istio_namespace" {
  metadata {
    name = var.istio_namespace
  }
}

# Namespace for YBA
resource "kubernetes_namespace" "yba_namespace" {
  metadata {
    name = var.yba_namespace
    labels = {
      istio-injection = "enabled"
    }
  }
}

# Create the universe management service account
resource "kubernetes_service_account" "universe_management_sa" {
  depends_on = [kubernetes_namespace.yba_namespace]
  metadata {
    name      = var.universe_management_sa
    namespace = var.yba_namespace
  }
}

# Create the universe management role binding
resource "kubernetes_cluster_role_binding" "universe_management_cluster_role_binding" {
  depends_on = [kubernetes_service_account.universe_management_sa]
  metadata {
    name = var.universe_management_cluster_role_binding
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    namespace = var.yba_namespace
    kind      = "ServiceAccount"
    name      = var.universe_management_sa
  }

}

# Create the universe management sa token
resource "kubernetes_secret" "universe_management_sa_token" {
  depends_on = [kubernetes_service_account.universe_management_sa]
  metadata {
    name      = var.universe_management_sa
    namespace = var.yba_namespace
    annotations = {
      "kubernetes.io/service-account.name" = var.universe_management_sa
    }
  }
  type = "kubernetes.io/service-account-token"
}

# Namespace for the universe pods
resource "kubernetes_namespace" "universe_namespace" {
  metadata {
    name = var.universe_namespace
    labels = {
      istio-injection = "enabled"
    }
  }
}
