variable "node_pool_name" {
  description = "The name of the GPU node pool"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "location" {
  description = "The region or zone for the node pool"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the pool"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for GPU nodes"
  type        = string
  default     = "n1-standard-4"
}

# variable "gpu_type" {
#  description = "GPU type for nodes"
#  type        = string
#  default     = "nvidia-h100-80gb"
# }

 variable "gpu_type" {
   description = "GPU type for nodes"
   type        = string
   default     = "nvidia-tesla-t4"
 }

variable "gpu_count" {
  description = "Number of GPUs per node"
  type        = number
  default     = 1
}

variable "oauth_scopes" {
  description = "OAuth scopes for node permissions"
  type        = list(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "node_tags" {
  description = "Tags for the node instances"
  type        = list(string)
  default     = []
}

variable "disk_size_gb" {
  description = "Size of the node's boot disk"
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "Type of the node's boot disk"
  type        = string
  default     = "pd-standard"
}

variable "min_node_count" {
  description = "Minimum number of GPU nodes in the pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of GPU nodes in the pool"
  type        = number
  default     = 5
}

variable "cluster_dependency" {
  description = "Reference to the GKE cluster resource to enforce dependency ordering"
  type        = any
}