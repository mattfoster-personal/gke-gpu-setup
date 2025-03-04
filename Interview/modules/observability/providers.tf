provider "kubernetes" {
  host                   = "https://${var.cluster_endpoint}"
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  config_path = pathexpand("~/.kube/config")
}

provider "helm" {
  kubernetes {
    host                   = "https://${var.cluster_endpoint}"
    config_path = pathexpand("~/.kube/config")
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  }
}

