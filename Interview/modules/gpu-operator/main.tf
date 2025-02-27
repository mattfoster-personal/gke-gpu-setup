# Helm Release for NVIDIA GPU Operator
resource "helm_release" "nvidia_gpu_operator" {
  #count      = length(var.cluster_dependency) > 0 ? 1 : 0 #split up applys instead can't figure how to make work
  name       = "gpu-operator"
  repository = "https://nvidia.github.io/gpu-operator"
  chart      = "gpu-operator"
  namespace  = "gpu-operator"
  create_namespace = true
  #depends_on = [var.cluster_dependency]
  depends_on = [var.cluster_dependency, var.node_pool_dependency]

  set {
    name  = "imagePullSecrets[0].name"
    value = "nvidia-secret"
  }

  set {
    name  = "tolerations[0].key"
    value = "nvidia.com/gpu"
  }
  set {
    name  = "tolerations[0].operator"
    value = "Exists"
  }
  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }

  set {
    name  = "operator.defaultRuntime"
    value = "containerd"
  }
}

# Kubernetes DaemonSet for NVIDIA Driver Installer
resource "kubernetes_daemonset" "nvidia_driver_installer" {
  metadata {
    name      = "nvidia-driver-installer"
    namespace = "kube-system"
  }

  spec {
    selector {
      match_labels = {
        name = "nvidia-driver-installer"
      }
    }

    template {
      metadata {
        labels = {
          name = "nvidia-driver-installer"
        }
      }

      spec {
        toleration {
          key      = "nvidia.com/gpu"
          operator = "Exists"
          effect   = "NoSchedule"
        }

        container {
          name  = "nvidia-driver-installer"
          image = "nvcr.io/nvidia/cuda:12.1.1-runtime-ubuntu22.04"

          security_context {
            privileged = true
          }

          volume_mount {
            mount_path = "/host"
            name       = "host-root"
          }
        }

        volume {
          name = "host-root"
          host_path {
            path = "/"
          }
        }
      }
    }
  }
}
