output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.gke_cluster.endpoint
}

output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "cluster_resource" {
  description = "Reference to the GKE cluster resource"
  value       = google_container_cluster.gke_cluster  # Expose the full resource
}