data "helm_repository" "astronomer_repo" {
  name       = "astronomer"
  url        = "https://helm.astronomer.io/"
}

# this is for development use
resource "helm_release" "astronomer_local" {
  count = var.local_umbrella_chart == "" ? 0 : 1
  name      = "astronomer"
  version   = var.astronomer_version
  chart     = "${path.module}/helm.astronomer.io"
  namespace = kubernetes_namespace.astronomer.metadata[0].name
  wait      = true
}

resource "helm_release" "astronomer" {
  count = var.local_umbrella_chart == "" ? 1 : 0
  name       = "astronomer"
  version    = var.astronomer_version
  chart      = "helm.astronomer.io"
  repository = data.helm_repository.astronomer_repo.name
  namespace  = kubernetes_namespace.astronomer.metadata[0].name
  wait       = true
}

