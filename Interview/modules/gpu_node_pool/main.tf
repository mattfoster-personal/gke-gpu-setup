resource "google_container_node_pool" "gpu_pool" {
  name       = "${var.cluster_name}-gpu-pool"
  cluster    = var.cluster_name
  location   = var.region
  node_count = var.node_count

  node_config {
    machine_type = "n1-standard-4"
    accelerators {
      accelerator_count = var.gpu_count
      accelerator_type  = var.gpu_type
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      gpu-node = "true"
    }

    taint {
      key    = "nvidia.com/gpu"
      value  = "present"
      effect = "NO_SCHEDULE"
    }

    image_type = "COS_CONTAINERD"
    disk_size_gb = var.disk_size
    disk_type    = var.disk_type
  }

  autoscaling {
    min_node_count = var.min_nodes
    max_node_count = var.max_nodes
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}
