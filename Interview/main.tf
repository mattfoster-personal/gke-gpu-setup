terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

module "gpu_operator" {
  source = "./modules/gpu_operator"
  cluster_endpoint       = module.gke_cluster.endpoint
  cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
  # node_pool_name         = module.gpu_node_pool.gpu_pool.name
  # cluster_name           = module.gke_cluster.gke_cluster.name

  depends_on = [module.gke_cluster, module.gpu_node_pool] 
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "gke_cluster" {
  source   = "./modules/cluster"
  cluster_name = "demo-cluster3"
 # project_id   = "gothic-province-450601-c2"
  project_id   = "ai-research-e44f"
  region       = "southamerica-east1"
}

module "gpu_node_pool" {
  node_count   = var.node_count
  source             = "./modules/gpu_node_pool"
  cluster_name       = module.gke_cluster.cluster_name
  node_pool_name     = "gpu-node-pool-test1"
  cluster_dependency = module.gke_cluster
  location = "test"
}