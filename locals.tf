locals {
  astronomer_values = <<EOF
---
global:
  # Base domain for all subdomains exposed through ingress
  baseDomain: ${var.base_domain}
  tlsSecret: astronomer-tls
  istioEnabled: ${var.enable_istio == "true" ? true : false}

%{if var.enable_gvisor == "true"}
  platformNodePool:
    affinity:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
          - matchExpressions:
            - key: "astronomer.io/multi-tenant"
              operator: In
              values:
              - "false"

  deploymentNodePool:
    affinity:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
          - matchExpressions:
            - key: "sandbox.gke.io/runtime"
              operator: In
              values:
              - "gvisor"
    tolerations:
    - effect: NoSchedule
      key: sandbox.gke.io/runtime
      operator: Equal
      value: gvisor
%{endif}

nginx:
  loadBalancerIP: ${var.load_balancer_ip == "" ? "~" : var.load_balancer_ip}
  privateLoadBalancer: ${var.cluster_type == "private" ? true : false}
  perserveSourceIP: true

astronomer:
%{if var.enable_gvisor == "true"}
  houston:
    config:
      deployments:
        helm:
          affinity:
            nodeAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                  - key: "sandbox.gke.io/runtime"
                    operator: In
                    values:
                    - "gvisor"
          tolerations:
          - effect: NoSchedule
            key: sandbox.gke.io/runtime
            operator: Equal
            value: gvisor
%{endif}
%{if var.gcp_default_service_account_key != ""}
  registry:
    gcs:
      enabled: true
      bucket: ${var.container_registry_bucket_name}
%{endif}  

EOF
}


