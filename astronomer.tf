# Initialize kubectl

resource "kubernetes_namespace" "astronomer" {
  metadata {
    name = "${var.astronomer_namespace}"

    labels {
      istio-injection = "enabled"
    }
  }
}

# Create prerequisite resources

resource "kubernetes_secret" "astronomer_bootstrap" {
  depends_on = ["kubernetes_namespace.astronomer"]

  metadata {
    name      = "astronomer-bootstrap"
    namespace = "${var.astronomer_namespace}"
  }

  type = "kubernetes.io/generic"

  data {
    "connection" = "${var.db_connection_string}"
  }
}

resource "kubernetes_secret" "astronomer_tls" {
  depends_on = ["kubernetes_namespace.astronomer"]

  metadata {
    name      = "astronomer-tls"
    namespace = "${var.astronomer_namespace}"
  }

  type = "kubernetes.io/tls"

  data {
    "tls.crt" = "${var.tls_cert}"
    "tls.key" = "${var.tls_key}"
  }
}

data "helm_repository" "astronomer_repo" {
  name = "astronomer"
  url  = "https://helm.astronomer.io/"
}

resource "helm_release" "astronomer" {
  # istio needs to be deployed first
  depends_on = ["helm_release.istio"]

  name      = "astronomer"
  version   = "${var.astronomer_version}"
  chart     = "astronomer"
  repository = "${data.helm_repository.astronomer_repo.name}"
  namespace = "${kubernetes_namespace.astronomer.metadata.name}"
  wait      = true

  values = [<<EOF
---
global:
  baseDomain: ${var.base_domain}
  tlsSecret: astronomer-tls
  istioEnabled: ${var.enable_istio == "true" ? true: false}
nginx:
  loadBalancerIP: ${var.load_balancer_ip == "" ? "~": var.load_balancer_ip}
  privateLoadBalancer: ${var.cluster_type == "private" ? true: false}
  perserveSourceIP: true
EOF
  ]
}
