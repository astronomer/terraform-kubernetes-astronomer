data "helm_repository" "rimusz" {
  depends_on = [module.tiller]
  count      = var.enable_cloud_sql_proxy ? 1 : 0
  name       = "rimusz"
  url        = "https://charts.rimusz.net"
}

resource "helm_release" "cloud_sql_proxy" {
  depends_on = [module.tiller]
  count      = var.enable_cloud_sql_proxy ? 1 : 0
  name       = "pg-sqlproxy"
  repository = data.helm_repository.rimusz[0].name
  chart      = "gcloud-sqlproxy"
  namespace  = kubernetes_namespace.astronomer[0].metadata[0].name
  wait       = true


  set {
    name  = "serviceAccountKey"
    value = base64encode(var.gcp_service_account_key_json)
  }
  set {
    name  = "cloudsql.instances[0].instance"
    value = var.cloudsql_instance
  }
  set {
    name  = "cloudsql.instances[0].project"
    value = var.gcp_project
  }
  set {
    name  = "cloudsql.instances[0].region"
    value = var.gcp_region
  }
  set {
    name  = "cloudsql.instances[0].port"
    value = "5432"
  }
}
