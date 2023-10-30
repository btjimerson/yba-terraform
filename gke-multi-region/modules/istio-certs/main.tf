// Create self-signed certs for Istio multicluster
resource "null_resource" "create_certs" {
  provisioner "local-exec" {
    command = <<-EOT
    pushd ${path.module}
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${var.istio_version} sh -
    mkdir -p certs
		cd certs
		make -f ../istio-${var.istio_version}/tools/certs/Makefile.selfsigned.mk root-ca
		make -f ../istio-${var.istio_version}/tools/certs/Makefile.selfsigned.mk ${var.cluster_1_name}-cacerts
		make -f ../istio-${var.istio_version}/tools/certs/Makefile.selfsigned.mk ${var.cluster_2_name}-cacerts
    popd
    rm -rf ${path.module}/istio-${var.istio_version}
	  EOT
  }
}

// Read certs
data "external" "cluster_1_ca_cert" {
  depends_on = [null_resource.create_certs]
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(cat ${path.module}/certs/${var.cluster_1_name}/ca-cert.pem)\" '{$content}'"
  ]
}
data "external" "cluster_1_ca_key" {
  depends_on = [null_resource.create_certs]
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(cat ${path.module}/certs/${var.cluster_1_name}/ca-key.pem)\" '{$content}'"
  ]
}
data "external" "cluster_1_root_cert" {
  depends_on = [null_resource.create_certs]
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(cat ${path.module}/certs/${var.cluster_1_name}/root-cert.pem)\" '{$content}'"
  ]
}
data "external" "cluster_1_cert_chain" {
  depends_on = [null_resource.create_certs]
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(cat ${path.module}/certs/${var.cluster_1_name}/cert-chain.pem)\" '{$content}'"
  ]
}
data "external" "cluster_2_ca_cert" {
  depends_on = [null_resource.create_certs]
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(cat ${path.module}/certs/${var.cluster_2_name}/ca-cert.pem)\" '{$content}'"
  ]
}
data "external" "cluster_2_ca_key" {
  depends_on = [null_resource.create_certs]
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(cat ${path.module}/certs/${var.cluster_2_name}/ca-key.pem)\" '{$content}'"
  ]
}
data "external" "cluster_2_root_cert" {
  depends_on = [null_resource.create_certs]
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(cat ${path.module}/certs/${var.cluster_2_name}/root-cert.pem)\" '{$content}'"
  ]
}
data "external" "cluster_2_cert_chain" {
  depends_on = [null_resource.create_certs]
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(cat ${path.module}/certs/${var.cluster_2_name}/cert-chain.pem)\" '{$content}'"
  ]
}

