provider "google" {
  project = var.project_id
  region  = var.region
}

module "gpu_node_pool" {
  source       = "./modules/gpu_node_pool"
  cluster_name = var.cluster_name
  node_count   = var.node_count
}

module "tenant_a" {
  source      = "./modules/tenant"
  tenant_name = "tenant-a"
}

module "tenant_b" {
  source      = "./modules/tenant"
  tenant_name = "tenant-b"
}
