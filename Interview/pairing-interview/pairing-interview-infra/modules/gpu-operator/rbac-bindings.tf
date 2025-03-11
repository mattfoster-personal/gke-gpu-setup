resource "kubernetes_cluster_role_binding" "cluster_admin" {
  metadata {
    name = "cluster-admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "User"
    name      = "mfoster@thoughtworks.com" #add your account here
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "gpu_operator_admin" {
  metadata {
    name = "gpu-operator-admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "User"
    name      = "mfoster@thoughtworks.com" #add your account here
    api_group = "rbac.authorization.k8s.io"
  }
}
