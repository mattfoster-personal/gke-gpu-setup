variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "GCP region where the cluster will be created"
  type        = string
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "workload_pool" {
  description = "Workload Identity Pool for GKE"
  type        = string
  default     = ""
}