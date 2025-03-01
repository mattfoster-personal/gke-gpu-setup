resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region

  # Enable release channel
  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range"
    services_secondary_range_name = "services-range"
  }

  # Enable logging and monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Set default max pods per node
  default_max_pods_per_node = 110



  # Node configuration
  node_config {
    machine_type = "n1-standard-4"
    image_type   = "UBUNTU_CONTAINERD"
    disk_type    = "pd-standard"
    disk_size_gb = 1000

    # Node labels
    labels = {
      "gke-no-default-nvidia-gpu-device-plugin" = "true"
    }

    # Metadata
    metadata = {
      disable-legacy-endpoints = "true"
    }

    # Tags
    tags = ["nvidia-ingress-all"]
  }

  # Remove the default node pool
  remove_default_node_pool = false
  initial_node_count       = 1

  # Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Additional configurations
  deletion_protection       = false
  enable_kubernetes_alpha   = false
  network                   = var.network_name 
  subnetwork                = var.subnet_name
  security_posture_config {
    mode = "BASIC"
  }
  binary_authorization {
    evaluation_mode = "DISABLED"
  }
}
