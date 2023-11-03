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
  }
}

//This module is all local-exec calls because Istio
//doesn't have a Terraform provider or Helm chart to setup multicluster

// Set the kubeconfig
resource "null_resource" "set_gke_creds" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.gke_cluster_name} --region ${var.gcp_region} --project ${var.gcp_project_id}"
  }
}

// Download Istio
resource "null_resource" "download_istio" {
  provisioner "local-exec" {
    command = "curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${var.istio_version} sh -"
  }
}

// Create Istio namespace
resource "null_resource" "create_istio_namespace" {
  depends_on = [null_resource.set_gke_creds]
  provisioner "local-exec" {
    command = <<-EOT
      kubectl create namespace ${var.istio_namespace}
      kubectl label namespace ${var.istio_namespace} topology.istio.io/network=${var.istio_network_name} --overwrite=true
    EOT

  }
}

//Install certs secret
resource "null_resource" "istio_certs_secret" {
  depends_on = [
    null_resource.set_gke_creds,
    null_resource.create_istio_namespace
  ]
  provisioner "local-exec" {
    command = <<-EOT
      kubectl create secret generic cacerts -n ${var.istio_namespace} \
        --from-literal=ca-cert.pem='${var.istio_ca_cert}' \
        --from-literal=ca-key.pem='${var.istio_ca_key}' \
        --from-literal=root-cert.pem='${var.istio_root_cert}' \
        --from-literal=cert-chain.pem='${var.istio_cert_chain}'
      EOT
  }
}

// Apply IstioOperator configuration
resource "null_resource" "apply_istio_cluster_configuration" {
  depends_on = [
    null_resource.set_gke_creds,
    null_resource.download_istio,
    null_resource.istio_certs_secret
  ]
  provisioner "local-exec" {
    command = <<-EOT
      cat <<EOF | istio-${var.istio_version}/bin/istioctl install -y -f -
      apiVersion: install.istio.io/v1alpha1
      kind: IstioOperator
      spec:
        meshConfig:
          defaultConfig:
            proxyMetadata:
              ISTIO_META_DNS_CAPTURE: "true"
              ISTIO_META_DNS_AUTO_ALLOCATE: "true"
        values:
          global:
            meshID: ${var.istio_mesh_name}
            multiCluster:
              clusterName: ${var.istio_cluster_name}
            network: ${var.istio_network_name}
      EOF
    EOT
  }
}

// Apply east-west gateway
resource "null_resource" "apply_east_west_gateway" {
  depends_on = [
    null_resource.set_gke_creds,
    null_resource.apply_istio_cluster_configuration
  ]
  provisioner "local-exec" {
    command = <<-EOT
      istio-${var.istio_version}/samples/multicluster/gen-eastwest-gateway.sh \
        --mesh ${var.istio_mesh_name} \
        --cluster ${var.istio_cluster_name} \
        --network ${var.istio_network_name} | \
        istio-${var.istio_version}/bin/istioctl install -y -f -
    EOT
  }
}

// Expose istio services
resource "null_resource" "expose_istio_services" {
  depends_on = [
    null_resource.set_gke_creds,
    null_resource.apply_east_west_gateway
  ]
  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -n istio-system -f istio-${var.istio_version}/samples/multicluster/expose-services.yaml
    EOT
  }
}

// Create a secret to connect to the cluster
data "external" "cluster_secret" {
  depends_on = [
    null_resource.set_gke_creds,
    null_resource.apply_east_west_gateway
  ]
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(istio-${var.istio_version}/bin/istioctl x create-remote-secret --name=${var.istio_cluster_name})\" '{$content}'"
  ]
}

// Remove istio
resource "null_resource" "remove_istio" {
  depends_on = [
    null_resource.download_istio,
    null_resource.apply_istio_cluster_configuration,
    null_resource.apply_east_west_gateway,
    null_resource.expose_istio_services
  ]
  provisioner "local-exec" {
    command = "rm -rf istio-${var.istio_version}"
  }
}

