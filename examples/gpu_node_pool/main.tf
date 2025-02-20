module "gpu_node_pool" {
  source        = "../../modules/gpu_node_pool"
  cluster_name  = "interview-cluster"
  region        = "us-central1"
  node_count    = 1
  gpu_type      = "nvidia-tesla-t4"
  gpu_count     = 1
  disk_size     = 100
  disk_type     = "pd-standard"
  min_nodes     = 0
  max_nodes     = 2
}
