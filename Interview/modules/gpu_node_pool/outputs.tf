output "node_pool_name" {
  description = "The name of the GPU node pool"
  value       = google_container_node_pool.gpu_pool.name
}