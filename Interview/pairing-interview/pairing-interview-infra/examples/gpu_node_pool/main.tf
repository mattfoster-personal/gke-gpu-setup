module "gke_cluster" {
  source       = "../../modules/cluster"
  cluster_name = "demo-cluster3"
  region       = "southamerica-east1-c"
  #project_id   = "gothic-province-450601-c2"
  project_id   = "ai-research-e44f"
  network_name = module.gke_network.network_name
  subnet_name = module.gke_network.subnet_name
}

module "gke_network" {
  source = "../../modules/network"
  location = "southamerica-east1-c"
}

module "gpu_operator" {
  source = "../../modules/gpu-operator"
  cluster_endpoint       = module.gke_cluster.cluster_endpoint
  cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
  cluster_dependency = module.gke_cluster.cluster_resource
  node_pool_dependency = module.gpu_node_pool
  network_name = module.gke_network.network_name
}

module "gpu_node_pool" {
  source         = "../../modules/gpu-node-pool"
  cluster_dependency = module.gke_cluster.cluster_resource
  node_pool_name = "gpu-node-pool-test1"
  cluster_name  = var.cluster_name  # Pass the cluster name
  location       = "southamerica-east1-c"
  node_count     = 2
  machine_type   = "n1-standard-4"
  # gpu_type       = "nvidia-h100-80gb" # Default

  # Uncomment this line to switch to Tesla T4
   gpu_type       = "nvidia-tesla-t4"

  gpu_count      = 2
  node_tags      = ["gpu-node"]
  disk_size_gb   = 100
  disk_type      = "pd-ssd"
  min_node_count = 2
  max_node_count = 5
}

module "observability" {
  source = "../../modules/observability"
  cluster_endpoint       = module.gke_cluster.cluster_endpoint
  cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
  monitoring_namespace      = "observability"
  gpu_monitoring_namespace  = "gpu-observability"
}