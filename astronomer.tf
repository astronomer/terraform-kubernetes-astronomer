resource "null_resource" "helm_repo" {

  provisioner "local-exec" {
    command = <<EOF
    set -xe
    git config --global alias.nthlastcheckout '!nthlastcheckout'"() {
        git reflog |
        awk '\$3==\"checkout:\" {++n}
             n=='\$${1-1}' {print \$NF; exit}
             END {exit n!='\$${1-1}'}'
        }; nthlastcheckout \"\$@\""
    cd ${path.root}
    if [ ! -d ./helm.astronomer.io ]; then
      git clone https://github.com/astronomer/helm.astronomer.io.git
    fi
    if [ ${var.astronomer_version} != "master" ]; then
      cd helm.astronomer.io
      git checkout v${var.astronomer_version}
      VERSION=$(git nthlastcheckout)
      if [ $VERSION != v${var.astronomer_version} ]; then
        cd ..
        if [ ! -d ./backups ]; then
          mkdir backups
        fi
        mv helm.astronomer.io backups/helm.astronomer.io.$VERSION.${timestamp()}
        git clone https://github.com/astronomer/helm.astronomer.io.git
        cd helm.astronomer.io
        git checkout v${var.astronomer_version}
      fi
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

  name      = "astronomer"
  version   = var.astronomer_version
  chart     = "./helm.astronomer.io"
  namespace = var.astronomer_namespace
  wait      = true
  values    = [var.astronomer_helm_values]
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
  chart      = "helm.astronomer.io"
  repository = data.helm_repository.astronomer_repo.name
  namespace  = var.astronomer_namespace
  wait       = true
  values = [var.astronomer_helm_values]
}
*/
