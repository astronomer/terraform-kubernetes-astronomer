terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source = "astronomer/astronomer-aws/aws"
    }
    acme = {
      source = "terraform-providers/acme"
    }
    helm = {
      source = "hashicorp/helm"
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
