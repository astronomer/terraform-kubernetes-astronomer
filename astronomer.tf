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
    mv * astronomer || true
    cd astronomer
    git checkout ${var.astronomer_version_git_checkout}
    EOF
  }

  triggers = {
    build_number = "${timestamp()}"
  }
}

resource "helm_release" "astronomer_local" {
  count = var.astronomer_chart_git_repository == "" ? 0 : 1

  depends_on = [null_resource.helm_repo,
    null_resource.dependency_getter,
    kubernetes_secret.astronomer_bootstrap,
  kubernetes_secret.astronomer_tls]

  name      = "astronomer"
  namespace = var.astronomer_namespace
  wait      = var.wait_for_helm_chart
  timeout   = 900
  values    = [var.astronomer_helm_values]
  version   = var.astronomer_version

  # Use the local chart for github clone method, use
  # chart name for helm repo method.
  chart = var.astronomer_chart_git_repository == "" ? var.astronomer_helm_chart_name : "/tmp/astronomer-${var.astronomer_version_git_checkout}-${random_id.collision_avoidance.hex}/astronomer"

  # These settings only are applied when using a Helm chart repo
  repository = var.astronomer_chart_git_repository == "" ? data.helm_repository.astronomer_repo.name : null
}

data "helm_repository" "astronomer_repo" {
  url  = var.astronomer_helm_chart_repo_url
  name = var.astronomer_helm_chart_repo
}
