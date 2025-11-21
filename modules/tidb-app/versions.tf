# modules/tidb-app/versions.tf

terraform {
  required_providers {
    # 1. Kubectl provider (Existing)
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.17"
    }

    # 2. Kubernetes provider (FIXED: Required for creating Namespaces, etc.)
    kubernetes = {
      source  = "hashicorp/kubernetes"
      # Use the same version as defined in your root providers.tf (~> 2.38.0)
      version = "~> 2.38.0" 
    }

    # 3. Helm provider (FIXED: Required for deploying the TiDB Operator)
    helm = {
      source  = "hashicorp/helm"
      # Use the same version as defined in your root providers.tf (~> 3.1.0)
      version = "~> 3.1.0" 
    }
  }
}