resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  
  deletion_protection = false

  # # Remove the default node pool since we'll create our own
  # remove_default_node_pool = true
  initial_node_count       = 1

  # Enable metadata server explicitly
  enable_kubernetes_alpha = false

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
resource "google_compute_firewall" "allow_k8s_api_helm" {
  name    = "allow-k8s-api-helm"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443", "6443", "10250-10259"]
  }

  source_ranges = ["0.0.0.0/0"]

  description = "Allow Kubernetes API and Helm communication"
}
