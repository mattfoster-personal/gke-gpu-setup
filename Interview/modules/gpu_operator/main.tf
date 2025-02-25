# Helm Release for NVIDIA GPU Operator
resource "helm_release" "nvidia_gpu_operator" {
  name       = "gpu-operator"
  repository = "https://nvidia.github.io/gpu-operator"
  chart      = "gpu-operator"
  namespace  = "gpu-operator"
  create_namespace = true

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
          image = "nvcr.io/nvidia/cuda-driver:535.113.01-ubuntu22.04"

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
