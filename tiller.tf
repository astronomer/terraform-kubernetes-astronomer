module tiller {
  source             = "./modules/terraform-kubernetes-tiller"
  tiller_version     = var.tiller_version
  tiller_history_max = 5
}
