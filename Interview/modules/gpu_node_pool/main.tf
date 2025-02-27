resource "google_container_node_pool" "gpu_pool" {
  name       = var.node_pool_name
  cluster    = var.cluster_name
  node_count = var.node_count
  project    = "gothic-province-450601-c2" # Explicitly define project for now

  depends_on = [var.cluster_dependency]

  node_config {
    machine_type = var.machine_type
    oauth_scopes = var.oauth_scopes

#    workload_metadata_config {
#      mode = "GKE_METADATA" 
#    }

    # Enable GPUs (Default: H100)
    guest_accelerator {
      type  = var.gpu_type
      count = var.gpu_count
    }

    # Alternative Tesla T4 (uncomment to switch)
    # guest_accelerator {
    #   type  = "nvidia-tesla-t4"
    #   count = 1
    # }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    taint {
      key    = "nvidia.com/gpu"
      value  = "present"
      effect = "NO_SCHEDULE"
    }

    labels = {
      role = "gpu-node"
    }

    tags = var.node_tags

    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}
