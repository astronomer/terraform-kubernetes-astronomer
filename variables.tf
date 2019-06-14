variable "cluster_type" {
  type        = string
}

variable "db_connection_string" {
  type        = string
  description = "Should look something like this - postgres://username:password@endpoint:port"
}

variable "tls_cert" {
  type        = string
  description = "The signed certificate for the Astronomer Load Balancer. It should be signed by a certificate authorize and should have common name *.base_domain"
}

variable "tls_key" {
  type        = string
  description = "The private key corresponding to the signed certificate tls_cert."
}

variable "base_domain" {
  type = string
}

variable "private_load_balancer" {
  default = true
  type    = string
}

variable "local_umbrella_chart" {
  default = ""
  type    = string
}

variable "astronomer_version" {
  default = "v0.9.1-alpha.4"
  type    = string
}

variable "load_balancer_ip" {
  default = ""
  type    = string
}

variable "astronomer_namespace" {
  default     = "astronomer"
  type        = string
}

variable "enable_istio" {
  default     = "false"
  type        = string
}

variable "enable_gvisor" {
  default     = "false"
  type        = string
}

variable "smtp_uri" {
  type        = string
}
