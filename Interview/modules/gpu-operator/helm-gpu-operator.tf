resource "helm_release" "nvidia_gpu_operator" {
  name             = "nvidia-gpu-operator"
  namespace        = "gpu-operator"
  create_namespace = true
  repository       = "https://helm.ngc.nvidia.com/nvidia"
  chart            = "gpu-operator"
  version          = "v24.9.2"

  set {
    name  = "priorityClassName"
    value = "gpu-operator-priority"
  }

  set {
    name  = "driver.enabled"
    value = true
  }

values = [
  <<-EOT
nodeSelector:
  cloud.google.com/gke-nodepool: gpu-node-pool-test1  # Target the correct node pool

tolerations:
  - key: nvidia.com/gpu
    operator: Exists
    effect: NoSchedule
  EOT
]


  depends_on = [var.node_pool_dependency]
}