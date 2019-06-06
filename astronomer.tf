# Initialize kubectl

resource "kubernetes_namespace" "astronomer" {
  metadata {
    name = "${var.astronomer_namespace}"

    labels {
      istio-injection = "enabled"
    }
  }
}

# Create prerequisite resources

resource "kubernetes_secret" "astronomer_bootstrap" {
  depends_on = ["kubernetes_namespace.astronomer"]

  metadata {
    name      = "astronomer-bootstrap"
    namespace = "${var.astronomer_namespace}"
  }

  type = "kubernetes.io/generic"

  data {
    "connection" = "${var.db_connection_string}"
  }
}

resource "kubernetes_secret" "astronomer_tls" {
  depends_on = ["kubernetes_namespace.astronomer"]

  metadata {
    name      = "astronomer-tls"
    namespace = "${var.astronomer_namespace}"
  }

  type = "kubernetes.io/tls"

  data {
    "tls.crt" = "${var.tls_cert}"
    "tls.key" = "${var.tls_key}"
  }
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller_admin" {
  depends_on = ["kubernetes_service_account.tiller"]
  metadata {
      name = "tiller"
  }
  role_ref {
      api_group = "rbac.authorization.k8s.io"
      kind = "ClusterRole"
      name = "cluster-admin"
  }
  subject {
      kind = "ServiceAccount"
      name = "tiller"
      namespace = "kube-system"
  }
  provisioner "local-exec" {
    command = "helm init --service-account tiller --upgrade --wait"
  }
}

data "helm_repository" "astronomer_repo" {
  depends_on = ["kubernetes_cluster_role_binding.tiller_admin"]
  name = "astronomer"
  url  = "https://helm.astronomer.io/"
}

resource "helm_release" "astronomer" {
  depends_on = ["kubernetes_cluster_role_binding.tiller_admin", "helm_release.istio"]

  name      = "astronomer"
  version   = "${var.astronomer_version}"
  chart     = "astronomer"
  repository = "${data.helm_repository.astronomer_repo.name}"
  namespace = "${kubernetes_namespace.astronomer.metadata.0.name}"
  wait      = true

  set {
    name  = "global.istioEnabled"
    value = "${var.enable_istio == "true" ? true: false}"
  }

  set {
    name  = "global.baseDomain"
    value = "${var.base_domain}"
  }

  set {
    name  = "nginx.loadBalancerIp"
    value = "${var.load_balancer_ip == "" ? "~": var.load_balancer_ip}"
  }

  set {
    name  = "nginx.privateLoadBalancer"
    value = "${var.cluster_type == "private" ? true: false}"
  }

  set {
    name  = "nginx.perserveSourceIp"
    value = true
  }

  set {
    name  = "nginx.perserveSourceIp"
    value = true
  }
  values = [<<EOF
global:
  baseDomain: ~
  tlsSecret: ~
  acme: false
  rbacEnabled: true
  helmRepo: "https://helm.astronomer.io"
  helmHost: "tiller-deploy.kube-system.svc.cluster.local:44134"
  singleNamespace: false
  airflowEnabled: false
  istioEnabled: false
tags:
  platform: true
  monitoring: true
  logging: true
astronomer:
  orbit:
    resources:
      requests:
        cpu: "100m"
        memory: "256Mi"
      limits:
        cpu: "500m"
        memory: "1024Mi"
  houston:
    resources:
      requests:
        cpu: "250m"
        memory: "512Mi"
      limits:
        cpu: "800m"
        memory: "1024Mi"
  prisma:
    resources:
      requests:
        cpu: "250m"
        memory: "512Mi"
      limits:
        cpu: "500m"
        memory: "1024Mi"
  commander:
    resources:
      requests:
        cpu: "250m"
        memory: "512Mi"
      limits:
        cpu: "500m"
        memory: "1024Mi"
  registry:
    resources:
      requests:
        cpu: "250m"
        memory: "512Mi"
      limits:
        cpu: "500m"
        memory: "1024Mi"
    persistence:
      enabled: true
      size: "100Gi"
  install:
    resources:
      requests:
        cpu: "100m"
        memory: "256Mi"
      limits:
        cpu: "500m"
        memory: "1024Mi"
  kubeReplicator:
    resources:
      requests:
        cpu: "100m"
        memory: "256Mi"
      limits:
        cpu: "500m"
        memory: "1024Mi"
nginx:
  resources:
    requests:
      cpu: "500m"
      memory: "1024Mi"
    limits:
      cpu: "1"
      memory: "2048Mi"
  loadBalancerIP:
  loadBalancerSourceRanges:
grafana:
  resources:
    requests:
      cpu: "250m"
      memory: "512Mi"
    limits:
      cpu: "500m"
      memory: "1024Mi"
prometheus:
  retention: 15d
  persistence:
    enabled: true
    size: "100Gi"
  resources:
    requests:
      cpu: "1000m"
      memory: "4Gi"
    limits:
      cpu: "1000m"
      memory: "4Gi"
elasticsearch:
  common:
    persistence:
      enabled: true
  client:
    heapMemory: "2g"
    resources:
      requests:
        cpu: "1"
        memory: "2Gi"
      limits:
        cpu: "2"
        memory: "4Gi"
  data:
    heapMemory: "2g"
    resources:
      requests:
        cpu: "1"
        memory: "2Gi"
      limits:
        cpu: "2"
        memory: "4Gi"
    persistence:
      size: "100Gi"
  master:
    heapMemory: "2g"
    resources:
      requests:
        cpu: "1"
        memory: "2Gi"
      limits:
        cpu: "2"
        memory: "4Gi"
    persistence:
      size: "20Gi"
kibana:
  resources:
    requests:
      cpu: "250m"
      memory: "512Mi"
    limits:
      cpu: "500m"
      memory: "1024Mi"
EOF
]
}
