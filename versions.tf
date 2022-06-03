terraform {
  required_version = ">= 1.0.2"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5"
    }
  }
}

