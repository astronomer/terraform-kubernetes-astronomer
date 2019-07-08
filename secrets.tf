# Create prerequisite resources
resource "kubernetes_secret" "astronomer_bootstrap" {
  depends_on = [null_resource.dependency_getter]

  metadata {
    name      = "astronomer-bootstrap"
    namespace = var.astronomer_namespace
  }

  type = "kubernetes.io/generic"

  data = {
    "connection" = var.db_connection_string
  }
}

resource "kubernetes_secret" "astronomer_tls" {
  depends_on = [null_resource.dependency_getter]

  metadata {
    name      = "astronomer-tls"
    namespace = var.astronomer_namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = var.tls_cert
    "tls.key" = var.tls_key
  }
}
