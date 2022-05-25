terraform {
  required_version = ">= 0.12"
  required_providers {
  helm = {
      source  = "hashicorp/helm"
      version = "~> 0.10"
    }
  }
}