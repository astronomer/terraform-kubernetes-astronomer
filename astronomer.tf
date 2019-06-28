resource "null_resource" "helm_repo" {
  provisioner "local-exec" {
    command = <<EOF
    if [ ! -d ./helm.astronomer.io ]; then
      git clone https://github.com/astronomer/helm.astronomer.io.git
    fi
    cd "./helm.astronomer.io" && \
    git checkout ${var.astronomer_version}
    EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm -rf './helm.astronomer.io'"
  }
}

# this is for development use
resource "helm_release" "astronomer_local" {
  depends_on = ["null_resource.helm_repo"]
  name = "astronomer"
  version = var.astronomer_version
  chart = "./helm.astronomer.io"
  namespace = var.astronomer_namespace
  wait = true
  values = [local.astronomer_values]
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
  values = [local.astronomer_values]
}
*/
