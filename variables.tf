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

variable "enable_aws_cluster_autoscaler" {
  default     = false
  type        = string
  description = "Automatically scale out node pool(s) on AWS. Must set var.cluster_name"
}

variable "cluster_name" {
  default     = ""
  type        = string
  description = "Used only with var.enable_aws_cluster_autoscaler"
}

variable "aws_region" {
  default     = "us-east-1"
  type        = string
  description = "Used only with var.enable_aws_cluster_autoscaler"
}

variable "cloudsql_instance" {
  default     = ""
  type        = string
  description = "Used when enable_cloud_sql_proxy is true"
}

variable "gcp_region" {
  default     = ""
  type        = string
  description = "Used when enable_cloud_sql_proxy is true"
}

variable "gcp_project" {
  default     = ""
  type        = string
  description = "Used when enable_cloud_sql_proxy is true"
}

variable "gcp_service_account_key_json" {
  default     = ""
  type        = string
  description = "Used when enable_cloud_sql_proxy is true"
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
