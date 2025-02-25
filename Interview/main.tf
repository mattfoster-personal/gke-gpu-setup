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
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "gke_cluster" {
  source   = "./modules/cluster"
  location = var.location
}

module "gpu_node_pool" {
  source       = "./modules/gpu_node_pool"
  cluster_name  = module.gke_cluster.cluster_name  # Correctly reference the cluster
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
