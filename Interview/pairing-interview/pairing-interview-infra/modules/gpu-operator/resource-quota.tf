resource "kubernetes_resource_quota" "gpu_operator_quota" {
  metadata {
    name      = "gpu-operator-quota"
    namespace = kubernetes_namespace.gpu_operator.metadata[0].name
  }

  spec {
    hard = {
      "pods" = "100"
    }

    scope_selector {
      match_expression {
        operator = "In"
        scope_name = "PriorityClass"
        values = ["system-node-critical", "system-cluster-critical"]
      }
    }
  }
}
