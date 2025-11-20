## modules/network/outputs.tf

output "vpc_name" {
  description = "The name of the created VPC network"
  value       = google_compute_network.vpc_network.name
}

output "subnet_name" {
  description = "The name of the created subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "pods_range_name" {
  description = "The name of the secondary range for GKE Pods"
  value       = "pods" # Hardcoded in resource
}

output "services_range_name" {
  description = "The name of the secondary range for GKE Services"
  value       = "services" # Hardcoded in resource
}

output "vpc_details" {
  description = "VPC network details"
  value = {
    name  = google_compute_network.vpc_network.name
    id    = google_compute_network.vpc_network.id
    self_link = google_compute_network.vpc_network.self_link
  }
}

output "subnet_details" {
  description = "Subnet details (with secondary ranges)"
  value = {
    name  = google_compute_subnetwork.subnet.name
    cidr  = google_compute_subnetwork.subnet.ip_cidr_range
    secondary_ranges = {
      for r in google_compute_subnetwork.subnet.secondary_ip_range :
      r.range_name => r.ip_cidr_range
    }
  }
}