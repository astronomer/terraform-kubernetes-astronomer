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

resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller_admin" {
  depends_on = ["kubernetes_service_account.tiller"]
  metadata {
      name = "tiller"
  }
  role_ref {
      api_group = "rbac.authorization.k8s.io"
      kind = "ClusterRole"
      name = "cluster-admin"
  }
  subject {
      kind = "ServiceAccount"
      name = "tiller"
      namespace = "kube-system"
  }
  provisioner "local-exec" {
    command = "helm init --service-account tiller --upgrade --wait"
  }
}

data "helm_repository" "astronomer_repo" {
  depends_on = ["kubernetes_cluster_role_binding.tiller_admin"]
  name = "astronomer"
  url  = "https://helm.astronomer.io/"
}

resource "helm_release" "astronomer" {
  depends_on = ["kubernetes_cluster_role_binding.tiller_admin", "helm_release.istio"]

  name      = "astronomer"
  version   = "${var.astronomer_version}"
  chart     = "helm.astronomer.io"
  repository = "${data.helm_repository.astronomer_repo.name}"
  namespace = "${kubernetes_namespace.astronomer.metadata.0.name}"
  wait      = true

  set {
    name  = "global.istioEnabled"
    value = "${var.enable_istio == "true" ? true: false}"
  }

  set {
    name  = "global.baseDomain"
    value = "${var.base_domain}"
  }

  set {
    name  = "nginx.loadBalancerIp"
    value = "${var.load_balancer_ip == "" ? "~": var.load_balancer_ip}"
  }

  set {
    name  = "nginx.privateLoadBalancer"
    value = "${var.cluster_type == "private" ? true: false}"
  }

  set {
    name  = "nginx.perserveSourceIp"
    value = true
  }

  set {
    name  = "nginx.perserveSourceIp"
    value = true
  }
}
