module tiller {
  source = "./modules/terraform-kubernetes-tiller"
  tiller_version = var.tiller_version
}

# wait a sec for tiller to be ready before proceeding
resource null_resource wait_for_tiller {
  depends_on = [module.tiller]
   provisioner "local-exec" {
     command = "sleep 10"
   }
}
