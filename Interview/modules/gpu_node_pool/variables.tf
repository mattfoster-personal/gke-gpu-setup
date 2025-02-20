variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "The GCP region where the node pool is deployed"
  type        = string
}

variable "node_count" {
  description = "The number of GPU nodes"
  type        = number
  default     = 1
}

variable "gpu_type" {
  description = "The type of GPU to use"
  type        = string
  default     = "nvidia-tesla-t4"
}

variable "gpu_count" {
  description = "The number of GPUs per node"
  type        = number
  default     = 1
}

variable "disk_size" {
  description = "Disk size for each node"
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "Disk type for the GPU node"
  type        = string
  default     = "pd-standard"
}

variable "min_nodes" {
  description = "Minimum number of GPU nodes in the pool"
  type        = number
  default     = 0
}

variable "max_nodes" {
  description = "Maximum number of GPU nodes in the pool"
  type        = number
  default     = 3
}
