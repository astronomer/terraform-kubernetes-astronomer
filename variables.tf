variable "db_connection_string" {
  type        = string
  description = "Should look something like this - postgres://username:password@endpoint:port"
}

variable "tls_cert" {
  default     = ""
  type        = string
  description = "The signed certificate for the Astronomer Load Balancer. It should be signed by a certificate authorize and should have common name *.base_domain"
}

variable "tls_key" {
  default     = ""
  type        = string
  description = "The private key corresponding to the signed certificate tls_cert."
}

variable "astronomer_version_git_checkout" {
  description = "Verison of the helm chart to use, when using git clone method. This should exactly match what you would want to use with 'git checkout <this variable>'. This is ignored if astronomer_chart_git_repository is not configured."
  default     = "master"
  type        = string
}

variable "astronomer_chart_git_repository" {
  description = "Git repository clone url, when using git clone method. This should exactly match what you would want to use with 'git clone <this variable>'. It is better to not use this and instead use just the astronomer_version variable, which will pull from the Astronomer Helm chart repository."
  default     = ""
  type        = string
}

variable "astronomer_version" {
  description = "Verison of Helm chart to use, do not include a 'v' at the front"
  default     = "0.12.0-alpha.1"
  type        = string
}

variable "astronomer_chart_git_repository" {
  description = "Git repository clone url, when using git clone method. This should exactly match what you would want to use with 'git clone <this variable>'. It is better to not use this and instead use just the astronomer_version variable, which will pull from the Astronomer Helm chart repository."
  default     = ""
  type        = string
}

variable "astronomer_helm_chart_name" {
  description = "The name of the Astronomer Helm chart to install from the Astronomer Helm chart repository."
  default     = "astronomer"
  type        = string
}

variable "wait_for_helm_chart" {
  description = "Should we wait for Astronomer to come up before indicating the apply is complete?"
  default     = true
  type        = bool
}

variable "astronomer_helm_chart_repo" {
  description = "The name of the Astronomer Helm chart repo"
  default     = "astronomer"
  type        = string
}

variable "astronomer_helm_chart_repo_url" {
  description = "The url of the Astronomer Helm chart repo"
  default     = "https://helm.astronomer.io"
  type        = string
}

variable "astronomer_namespace" {
  default = "astronomer"
  type    = string
}

variable "gcp_default_service_account_key" {
  default = ""
  type    = string
}

# https://github.com/hashicorp/terraform/issues/1178
resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = join(",", var.dependencies)
  }
}

variable "dependencies" {
  default = [""]
  type    = list(string)
}

variable "astronomer_helm_values" {
  type        = string
  description = "Values in raw yaml to pass to helm to override defaults in Astronomer Helm Chart."
  default     = ""
}

variable "install_astronomer_helm_chart" {
  type        = bool
  default     = true
  description = "When false, this module skips installing the Astronomer helm chart. This is useful if you want to manage Astronomer outside of Terraform"
}
