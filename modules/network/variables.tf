## modules/network/variables.tf

variable "region" {
  description = "GCP region"
  type        = string
}

variable "vpc_name" {
  description = "VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "ip_cidr_range" {
  description = "Primary CIDR range for the subnet (Nodes)"
  type        = string
}

variable "pods_cidr_range" {
  description = "Secondary range for Pods"
  type        = string
}

variable "services_cidr_range" {
  description = "Secondary range for Services"
  type        = string
}