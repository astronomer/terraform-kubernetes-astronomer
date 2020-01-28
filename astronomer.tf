resource "random_id" "collision_avoidance" {
  byte_length = 8
}

resource "null_resource" "helm_repo" {

  provisioner "local-exec" {
    command = <<EOF
    set -xe
    export directory=/tmp/astronomer-${var.astronomer_version}-${random_id.collision_avoidance.hex}
    rm -rf $directory
    mkdir -p $directory
    cd $directory
    git clone https://github.com/astronomer/helm.astronomer.io.git
    if [ ${var.astronomer_version} != "master" ]; then
      cd helm.astronomer.io
      git checkout v${var.astronomer_version}
    fi
    EOF
  }

  triggers = {
    build_number = "${timestamp()}"
  }
}

# this is for development use
resource "helm_release" "astronomer_local" {
  depends_on = [null_resource.helm_repo,
    null_resource.dependency_getter,
    kubernetes_secret.astronomer_bootstrap,
  kubernetes_secret.astronomer_tls]

  name = "astronomer"
  version = var.astronomer_version
  chart = "/tmp/astronomer-${var.astronomer_version}-${random_id.collision_avoidance.hex}/helm.astronomer.io"
  namespace = var.astronomer_namespace
  wait = true
  timeout = 900
  values = [var.astronomer_helm_values]
}

/*
data "helm_repository" "astronomer_repo" {
  name       = var.astronomer_namespace
  url        = "https://helm.astronomer.io/"
}


resource "helm_release" "astronomer" {
  count = var.local_umbrella_chart == "" ? 1 : 0
  name       = "astronomer"
  version    = var.astronomer_version
  chart      = "/tmp/astronomer-${var.astronomer_version}-${random_id.collision_avoidance.hex}"
  repository = data.helm_repository.astronomer_repo.name
  namespace  = var.astronomer_namespace
  wait       = true
  values = [var.astronomer_helm_values]
}
*/
