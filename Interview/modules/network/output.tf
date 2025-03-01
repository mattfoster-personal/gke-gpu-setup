output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.gke_network.name
}

output "subnet_name" {
  description = "The name of the GKE subnetwork"
  value       = google_compute_subnetwork.gke_subnet.name
}