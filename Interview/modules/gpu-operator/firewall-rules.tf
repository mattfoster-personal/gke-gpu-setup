resource "google_compute_firewall" "allow_helm" {
  name    = "allow-helm-access"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["443", "6443"] # Allow Kubernetes API and Helm
  }

  source_ranges = ["0.0.0.0/0"] # Open access (restrict if needed)
}
