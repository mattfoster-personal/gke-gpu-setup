variable "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "The CA certificate of the GKE cluster"
  type        = string
}

variable "cluster_dependency" {
  description = "Ensures the cluster is created before deploying GPU Operator"
  type        = any
}

variable "node_pool_dependency" {
  description = "Ensures the GPU node pool is created before deploying GPU Operator"
  type        = any
}