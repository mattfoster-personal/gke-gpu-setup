terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "gpu_node_pool" {
  source       = "./modules/gpu_node_pool"
  cluster_name = module.cluster.cluster_name
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
