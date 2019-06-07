variable "db_connection_string" {
  type    = "string"
  description = "Should look something like this - postgres://username:password@endpoint:port"
}

variable "tls_cert" {
  type    = "string"
  description = "The signed certificate for the Astronomer Load Balancer. It should be signed by a certificate authorize and should have common name *.base_domain"
}

variable "tls_key" {
  type    = "string"
  description = "The private key corresponding to the signed certificate tls_cert."
}

variable "base_domain" {
  type = "string"
}

variable "cluster_type" {
  default = "private"
  type    = "string"
}

variable "enable_istio" {
  default = "false"
  type    = "string"
}

variable "istio_helm_release_version" {
  default = "1.1.7"
  type    = "string"
}

variable "local_umbrella_chart" {
  default = ""
  type    = "string"
}

variable "astronomer_version" {
  default = "v0.9.1-alpha.5"
  type    = "string"
}

variable "load_balancer_ip" {
  default = ""
  type    = "string"
}

variable "astronomer_namespace" {
  default = "astronomer"
  type    = "string"
}

variable "admin_email" {
  description = "An email address"
  type        = "string"
}
