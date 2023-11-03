terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

# Get the kubeconfig
resource "null_resource" "cluster_kubeconfig" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.gke_cluster_name} --region ${var.gcp_region} --project ${var.gcp_project_id}"
  }
}

# Pull secret for YBA
resource "kubernetes_secret" "yugabyte_pull_secret" {
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
