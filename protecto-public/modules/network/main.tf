## modules/network/main.tf

# -------------------------
# VPC (Virtual Private Cloud) Network
# -------------------------
resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# -------------------------
# Subnet with Secondary IP Ranges for GKE
# -------------------------
resource "google_compute_subnetwork" "subnet" {
  name            = var.subnet_name
  region          = var.region
  network         = google_compute_network.vpc_network.id
  ip_cidr_range   = var.ip_cidr_range # Primary range for GKE Nodes

  # Secondary range for Kubernetes Pods
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr_range
  }

  # Secondary range for Kubernetes Services
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr_range
  }
}

# -------------------------
# Cloud Router (prerequisite for Cloud NAT)
# -------------------------
resource "google_compute_router" "nat_router" {
  name    = "${var.vpc_name}-nat-router"
  region  = var.region
  network = google_compute_network.vpc_network.id

  depends_on = [
    google_compute_network.vpc_network
  ]
}

# -------------------------
# Cloud NAT (Network Address Translation)
# -------------------------
resource "google_compute_router_nat" "nat" {
  name                           = "${var.vpc_name}-nat"
  router                         = google_compute_router.nat_router.name
  region                         = var.region
  nat_ip_allocate_option         = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  enable_endpoint_independent_mapping = true

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  depends_on = [
    google_compute_router.nat_router
  ]
}