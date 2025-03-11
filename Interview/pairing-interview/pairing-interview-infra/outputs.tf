output "gpu_node_pool_name" {
  description = "Name of the GPU node pool"
  value       = module.gpu_node_pool.node_pool_name
}

output "tenant_a_namespace" {
  description = "Kubernetes namespace for Tenant A"
  value       = module.tenant_a.namespace
}

output "tenant_b_namespace" {
  description = "Kubernetes namespace for Tenant B"
  value       = module.tenant_b.namespace
}
