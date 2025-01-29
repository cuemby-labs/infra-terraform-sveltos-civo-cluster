terraform {
  required_providers {
    civo = {
      source  = "civo/civo"
      version = ">= 1.1.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 1.6.0"
}