data "http" "local_ip" {
  url = "https://api.ipify.org/"
}

module "astronomer_gcp" {
  source = "github.com/astronomer/terraform-google-astronomer-gcp//terraform?ref=remove-tiller"

  deployment_id              = var.deployment_id
  dns_managed_zone           = "astrodev"
  email                      = "infrastructure@astronomer.io"
  zonal_cluster              = var.zonal
  management_endpoint        = "public"
  kube_api_whitelist_cidr    = ["${trimspace(data.http.local_ip.response_body)}/32"]
  enable_gke_metered_billing = true
  db_max_connections         = 1000
  db_version                 = "POSTGRES_14"
  db_deletion_protection     = false
}

module "system_components" {
  source = "github.com/astronomer/terraform-kubernetes-astronomer-system-components//terraform?ref=remoev-tiller"

  astronomer_namespace         = var.astronomer_namespace
  gcp_service_account_key_json = module.astronomer_gcp.gcp_cloud_sql_admin_key
  cloudsql_instance            = module.astronomer_gcp.db_instance_name
  gcp_region                   = module.astronomer_gcp.gcp_region
  gcp_project                  = module.astronomer_gcp.gcp_project
  enable_knative               = false
  enable_kubecost              = false
  enable_cloud_sql_proxy       = false
  enable_istio                 = false
  enable_velero                = false

  dependencies = [module.astronomer_gcp.depended_on]
}

module "astronomer" {
  source = "../terraform"

  astronomer_namespace           = var.astronomer_namespace
  install_astronomer_helm_chart  = true
  astronomer_version             = var.astronomer_version
  astronomer_helm_chart_repo_url = "https://helm.astronomer.io"

  db_connection_string = module.astronomer_gcp.db_connection_string

  astronomer_helm_values = <<EOF
---
global:
  # Base domain for all subdomains exposed through ingress
  baseDomain: ${module.astronomer_gcp.base_domain}
  tlsSecret: astronomer-tls
  istioEnabled: false
  postgresqlEnabled: false

nginx:
  loadBalancerIP: "~"
  privateLoadBalancer: true
  perserveSourceIP: true
EOF

  dependencies = [
    module.system_components.depended_on
  ]
}
