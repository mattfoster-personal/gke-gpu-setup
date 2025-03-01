resource "google_container_node_pool" "gpu_node_pool" {
  name       = var.node_pool_name
  cluster    = var.cluster_name
  location   = var.location
  node_count = 1

  node_config {
    machine_type = var.machine_type
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb
    image_type = "UBUNTU_CONTAINERD"

    # GPU configuration
    guest_accelerator {
      type  = var.gpu_type
      count = var.gpu_count

    gpu_driver_installation_config {
        gpu_driver_version = "DEFAULT"  # Ensures NVIDIA drivers are installed
      }
    }

    # Node labels
    labels = {
      "gke-no-default-nvidia-gpu-device-plugin" = "true"
    }

    # Metadata
    metadata = {
      disable-legacy-endpoints = "true"
    }

    # Tags
    tags = var.node_tags
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  # Enable GPU-specific features
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  depends_on = [var.cluster_dependency]
    # Ensure Terraform ignores GPU node pool changes
  lifecycle {
    ignore_changes = [node_count, autoscaling]
  }
}
