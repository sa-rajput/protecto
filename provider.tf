## Root provider.tf
## Configures the required providers and the Google provider authentication.

terraform {
  required_providers {
    # Kubernetes provider
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
    # Helm provider
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.0"
    }
    # kubectl provider (already fixed, keeping here for completeness)
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.17"
    }
    # http data source is also needed by the module
    http = {
      source = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  # If credentials var is provided, use the file; otherwise, rely on ADC/ENV vars.
  credentials = var.credentials != "" ? file(var.credentials) : null
}