terraform {
  required_version = ">= 0.13"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 0.10"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
