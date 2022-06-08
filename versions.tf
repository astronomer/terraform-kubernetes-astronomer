terraform {
  required_version = ">= 0.13"
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.5.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.3.1"
    }
  }
}