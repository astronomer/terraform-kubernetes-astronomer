# this is a workaround to allow JIT
# initialization of these providers
# https://github.com/hashicorp/terraform/issues/2430

resource "local_file" "kubeconfig" {
  depends_on = [module.aws]
  content    = module.aws.kubeconfig
  filename   = "${path.root}/kubeconfig"
}

provider "kubernetes" {
  config_path      = local_file.kubeconfig.filename
  load_config_file = true
}

provider "helm" {
  kubernetes {
    config_path      = local_file.kubeconfig.filename
    load_config_file = true
  }
}