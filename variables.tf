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

