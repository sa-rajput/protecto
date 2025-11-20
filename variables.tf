## Root variables.tf
## No default values are set for production environment to enforce explicit configuration.

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for all resources (e.g., asia-south1)"
  type        = string
}

variable "zone" {
  description = "GCP zone within the region for node placement (e.g., asia-south1-a)"
  type        = string
}

variable "credentials" {
  description = "Path to the GCP Service Account key file (e.g., 'key.json'). Leave blank to use ADC."
  type        = string
}

# --- Network Variables ---
variable "vpc_name" {
  description = "VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "ip_cidr_range" {
  description = "Primary CIDR range for the subnet (GKE Nodes)"
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

# --- GKE Cluster Variables ---
variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

# --- Node Pool Counts ---
variable "admin_count" {
  description = "Number of nodes in the 'admin' node pool"
  type        = number
}

variable "bignode_count" {
  description = "Number of nodes in the 'bignode' node pool"
  type        = number
}

# --- Node Pool Configurations (TiDB specific) ---
variable "tidb_count" {
  description = "Number of nodes in the 'tidb' pool"
  type        = number
}
variable "tidb_machine_type" {
  description = "Machine type for 'tidb' pool"
  type        = string
}
variable "tidb_disk_gb" {
  description = "Disk size for 'tidb' pool"
  type        = number
}

variable "pd_count" {
  description = "Number of nodes in the 'pd' pool"
  type        = number
}
variable "pd_machine_type" {
  description = "Machine type for 'pd' pool"
  type        = string
}
variable "pd_disk_gb" {
  description = "Disk size for 'pd' pool"
  type        = number
}

variable "tikv_count" {
  description = "Number of nodes in the 'tikv' pool"
  type        = number
}
variable "tikv_machine_type" {
  description = "Machine type for 'tikv' pool"
  type        = string
}
variable "tikv_disk_gb" {
  description = "Disk size for 'tikv' pool"
  type        = number
}

