locals {
  astronomer_values = <<EOF
---
global:
  baseDomain: ${var.base_domain}
  tlsSecret: astronomer-tls
  istioEnabled: ${var.enable_istio == "true" ? true : false}
nginx:
  loadBalancerIP: ${var.load_balancer_ip == "" ? "~" : var.load_balancer_ip}
  privateLoadBalancer: ${var.cluster_type == "private" ? true : false}
  perserveSourceIP: true
EOF

}

