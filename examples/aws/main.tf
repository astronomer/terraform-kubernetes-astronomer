variable deployment_id {}

variable route53_domain {
  default = "astronomer-development.com"
}

module "aws" {
  source         = "astronomer/astronomer-aws/aws"
  version        = "1.1.101"
  deployment_id  = var.deployment_id
  admin_email    = "steven@astronomer.io"
  route53_domain = var.route53_domain
  enable_bastion = false
  tags = {
    "CI" = true
  }
  cluster_type   = "private"
  management_api = "public"
}

# install tiller, which is the server-side component
# of Helm, the Kubernetes package manager
module "system_components" {
  dependencies = [module.aws.depended_on]
  source       = "astronomer/astronomer-system-components/kubernetes"
  enable_istio = "false"
}

module "astronomer" {
  dependencies         = [module.system_components.depended_on]
  source               = "../.."
  db_connection_string = module.aws.db_connection_string
  tls_cert             = module.aws.tls_cert
  tls_key              = module.aws.tls_key

  astronomer_helm_values = <<EOF
---
global:
  # Base domain for all subdomains exposed through ingress
  baseDomain: ${module.aws.base_domain}
  tlsSecret: astronomer-tls
  istioEnabled: false

nginx:
  loadBalancerIP: "~"
  privateLoadBalancer: true
  perserveSourceIP: true
EOF
}

data "aws_lambda_invocation" "elb_name" {
  depends_on    = [module.astronomer]
  function_name = "${module.aws.elb_lookup_function_name}"
  input         = "{}"
}

data "aws_elb" "nginx_lb" {
  name = data.aws_lambda_invocation.elb_name.result_map["Name"]
}

data "aws_route53_zone" "selected" {
  name = "${var.route53_domain}."
}

resource "aws_route53_record" "astronomer" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "*.${var.deployment_id}.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = "30"
  records = [data.aws_elb.nginx_lb.dns_name]
}
