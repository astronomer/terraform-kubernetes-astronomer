variable "region" {
  type = string
}

variable "project_id" {
  type = string
}

variable "deployment_id" {
  type = string
}

variable "zonal" {
  type    = bool
  default = false
}

variable "spotinist_token" {
  type    = string
  default = "12345"
}

variable "astronomer_namespace" {
  default     = "astronomer"
  type        = string
  description = "The namespace that will be created and Astronomer will be installed"
}

variable "astronomer_version" {
  description = "Version of Helm chart to use, do not include a 'v' at the front"
  type        = string
}
