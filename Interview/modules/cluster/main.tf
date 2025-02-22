resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  
  deletion_protection = false

  # Remove the default node pool since we'll create our own
  remove_default_node_pool = true
  initial_node_count       = 1

  # Enable metadata server explicitly
  enable_kubernetes_alpha = true

  # Enable security settings for Workload Identity
  security_posture_config {
    mode = "BASIC"
  }

  binary_authorization {
    evaluation_mode = "DISABLED"
  }

  # Networking
  network    = "default"
  subnetwork = "default"
}
