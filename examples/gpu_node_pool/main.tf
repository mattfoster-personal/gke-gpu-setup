module "gke_cluster" {
  source       = "../../Interview/modules/cluster"
  cluster_name = "demo-cluster2"
  region       = "southamerica-east1-c"
  project_id   = "gothic-province-450601-c2"
}

module "gpu_node_pool" {
  source         = "../../Interview/modules/gpu_node_pool"
  node_pool_name = "gpu-node-pool-test"
  cluster_name   = "demo-cluster2"
  location       = "southamerica-east1-c"
  node_count     = 1
  machine_type   = "n1-standard-4"
  # gpu_type       = "nvidia-h100-80gb" # Default

  # Uncomment this line to switch to Tesla T4
   gpu_type       = "nvidia-tesla-t4"

  gpu_count      = 1
  node_tags      = ["gpu-node"]
  disk_size_gb   = 100
  disk_type      = "pd-ssd"
  min_node_count = 0
  max_node_count = 5
}