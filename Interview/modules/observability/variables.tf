variable "monitoring_namespace" {
  description = "Namespace for Prometheus Operator"
  type        = string
  default     = "monitoring"
}

variable "gpu_monitoring_namespace" {
  description = "Namespace for DCGM Exporter"
  type        = string
  default     = "gpu-monitoring"
}

variable "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "The CA certificate of the GKE cluster"
  type        = string
}