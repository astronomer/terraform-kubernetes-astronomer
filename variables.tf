variable "enable_istio" {
  default = "false"
  type    = string
}

variable "istio_helm_release_version" {
  default = "1.1.7"
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
