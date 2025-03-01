resource "kubernetes_namespace" "gpu_operator" {
  metadata {
    name = "gpu-operator"
  }
}
