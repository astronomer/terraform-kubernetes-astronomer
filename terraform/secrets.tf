# Create prerequisite resources
resource "kubernetes_secret" "astronomer_bootstrap" {
  depends_on = [null_resource.dependency_getter]

  metadata {
    name      = "astronomer-bootstrap"
    namespace = var.astronomer_namespace
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-name"      = "astronomer"
      "meta.helm.sh/release-namespace" = "astronomer"
    }
  }

  type = "kubernetes.io/generic"

  data = {
    "connection" = var.db_connection_string
  }
}

resource "kubernetes_secret" "astronomer-gcs-keyfile" {
  # This logic will be worked out or deleted in a future release. Currently setting to to 1 because that has been required.
  #count = var.gcp_default_service_account_key != "" ? 1 : 0
  count = 1
  metadata {
    name      = "astronomer-gcs-keyfile"
    namespace = var.astronomer_namespace
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-name"      = "astronomer"
      "meta.helm.sh/release-namespace" = "astronomer"
    }
  }

  type = "kubernetes.io/generic"

  data = {
    "astronomer-gcs-keyfile" = var.gcp_default_service_account_key
  }
}
