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
  count      = var.tls_cert != "" && var.tls_key != "" ? 1 : 0
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

resource "kubernetes_secret" "astronomer-gcs-keyfile" {
  #count = var.gcp_default_service_account_key != "" ? 1 : 0
  count = 1
  metadata {
    name      = "astronomer-gcs-keyfile"
    namespace = var.astronomer_namespace
  }

  type = "kubernetes.io/generic"

  data = {
    "astronomer-gcs-keyfile" = var.gcp_default_service_account_key
  }
}
