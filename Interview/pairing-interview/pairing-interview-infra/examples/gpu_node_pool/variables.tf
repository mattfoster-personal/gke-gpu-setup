variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "southamerica-east1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "node_pool_name" {
  description = "The name of the GPU node pool"
  type        = string
  default     = "gpu-node-pool-test"
}

variable "machine_type" {
  description = "The machine type for the GPU nodes"
  type        = string
  default     = "n1-standard-4"
}

variable "gpu_type" {
  description = "The type of GPU to attach"
  type        = string
  default     = "nvidia-tesla-t4"
}
