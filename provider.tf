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
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0" # Use a compatible, recent version
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  # If credentials var is provided, use the file; otherwise, rely on ADC/ENV vars.
  credentials = var.credentials != "" ? file(var.credentials) : null
}

# -----------------------------------------------------
# Data sources for Kubernetes Authentication
# -----------------------------------------------------

data "google_client_config" "default" {}

# Provider configurations (now defined in the root as they depend on module outputs)
provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)

}

provider "kubectl" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  load_config_file       = false
}

provider "helm" {
  kubernetes = {
    host                   = "https://${data.google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}



# Use the read secrets in the Docker Provider
provider "docker" {
  # Add the Docker provider source to your required_providers block if not done:
  /*
  terraform {
    required_providers {
      docker = {
        source  = "kreuzwerker/docker"
        version = "~> 3.0"
      }
    }
  }
  */
  
  registry_auth {
    address  = var.private_registry_address
    # Use the data source output for username and password
    username = data.google_secret_manager_secret_version.docker_username_read.secret_data
    password = data.google_secret_manager_secret_version.docker_password_read.secret_data
  }
}