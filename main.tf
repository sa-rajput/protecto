## Root main.tf
## Calls the network, GKE cluster, and TiDB application modules.

# -----------------------------------------------------
# Module 1: Network Infrastructure
# -----------------------------------------------------
module "network" {
  source              = "./modules/network"
  region              = var.region
  vpc_name            = var.vpc_name
  subnet_name         = var.subnet_name
  ip_cidr_range       = var.ip_cidr_range
  pods_cidr_range     = var.pods_cidr_range
  services_cidr_range = var.services_cidr_range
}

# -----------------------------------------------------
# Module 2: GKE Cluster
# -----------------------------------------------------
module "gke_cluster" {
  source          = "./modules/gke-cluster"
  region          = var.region
  zone            = var.zone
  cluster_name    = var.cluster_name
  network_name    = module.network.vpc_name
  subnetwork_name = module.network.subnet_name
  
  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name
  
  admin_count     = var.admin_count
  tidb_config     = {
    count        = var.tidb_count
    machine_type = var.tidb_machine_type
    disk_gb      = var.tidb_disk_gb
  }
  pd_config       = {
    count        = var.pd_count
    machine_type = var.pd_machine_type
    disk_gb      = var.pd_disk_gb
  }
  tikv_config     = {
    count        = var.tikv_count
    machine_type = var.tikv_machine_type
    disk_gb      = var.tikv_disk_gb
  }
  bignode_count = var.bignode_count

  depends_on = [module.network]
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

data "google_container_cluster" "primary" {
  name     = module.gke_cluster.gke_name
  location = var.region
  
  # Ensure the data source explicitly waits for the GKE cluster resource to be created.
  depends_on = [
    module.gke_cluster
  ]
}



# -----------------------------------------------------
# Module 3: TiDB Application Deployment
# -----------------------------------------------------

module "tidb_app" {
  source            = "./modules/tidb-app"
  tidb_cluster_yaml = file("./tidb-yamls/tidb-cluster.yaml") # Using file() instead of var.tidb_yaml_path/tidb-cluster.yaml
  
  # Explicitly pass the provider configuration to the module
  providers = {
    kubectl    = kubectl
    kubernetes = kubernetes
    helm       = helm
  }
}