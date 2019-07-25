variable "enable_istio" {
  default = "false"
  type    = string
}

# https://cloud.google.com/sql/docs/postgres/
variable "enable_cloud_sql_proxy" {
  default     = false
  type        = string
  description = "A GCP feature for secure communication with Cloud SQL"
}

variable "istio_helm_release_version" {
  default = "1.1.7"
  type    = string
}

variable "tiller_version" {
  default = "2.14.1"
  type    = string
}

variable "tiller_namespace" {
  default = "kube-system"
  type    = string
}

variable "astronomer_namespace" {
  default = "astronomer"
  type    = string
}

# https://github.com/hashicorp/terraform/issues/1178
resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = "${join(",", var.dependencies)}"
  }
}
variable "dependencies" {
  default = [""]
  type    = list(string)
}
