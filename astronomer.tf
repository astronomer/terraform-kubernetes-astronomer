resource "random_id" "collision_avoidance" {
  byte_length = 8
}

resource "null_resource" "helm_repo" {
  count = var.astronomer_chart_git_repository == "" ? 0 : 1

  provisioner "local-exec" {
    command = <<EOF
    set -xe
    export directory=/tmp/astronomer-${var.astronomer_version_git_checkout}-${random_id.collision_avoidance.hex}
    rm -rf $directory
    mkdir -p $directory
    cd $directory
    git clone ${var.astronomer_chart_git_repository}
    mv * astronomer
    cd astronomer
    git checkout ${var.astronomer_version_git_checkout}
    EOF
  }

  triggers = {
    build_number = "${timestamp()}"
  }
}

resource "helm_release" "astronomer_with_git_clone" {
  count = var.astronomer_chart_git_repository == "" ? 0 : 1

  depends_on = [null_resource.helm_repo,
    null_resource.dependency_getter,
    kubernetes_secret.astronomer_bootstrap,
  kubernetes_secret.astronomer_tls]

  name      = "astronomer"
  chart     = "/tmp/astronomer-${var.astronomer_version_git_checkout}-${random_id.collision_avoidance.hex}/astronomer"
  namespace = var.astronomer_namespace
  wait      = var.wait_for_helm_chart
  timeout   = 900
  values    = [var.astronomer_helm_values]
}

data "helm_repository" "astronomer_repo" {
  url  = var.astronomer_helm_chart_repo_url
  name = var.astronomer_helm_chart_repo
}

resource "helm_release" "astronomer" {
  count = var.astronomer_chart_git_repository == "" ? 1 : 0

  depends_on = [null_resource.helm_repo,
    null_resource.dependency_getter,
    kubernetes_secret.astronomer_bootstrap,
  kubernetes_secret.astronomer_tls]

  version    = var.astronomer_version
  name       = var.astronomer_helm_chart_name
  chart      = var.astronomer_helm_chart_name
  repository = data.helm_repository.astronomer_repo.name
  namespace  = var.astronomer_namespace
  wait       = var.wait_for_helm_chart
  timeout    = 900
  values     = [var.astronomer_helm_values]
}
