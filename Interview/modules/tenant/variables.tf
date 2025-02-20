variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

variable "cpu_limit" {
  description = "CPU limit for the tenant"
  type        = string
  default     = "2"
}

variable "memory_limit" {
  description = "Memory limit for the tenant"
  type        = string
  default     = "4Gi"
}

variable "gpu_limit" {
  description = "GPU limit for the tenant"
  type        = string
  default     = "1"
}

variable "tenant_user" {
  description = "The user to bind roles for the tenant"
  type        = string
}
