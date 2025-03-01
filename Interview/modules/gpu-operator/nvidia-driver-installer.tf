# resource "kubernetes_daemonset" "nvidia_driver_installer" {
#   metadata {
#     name      = "nvidia-driver-installer"
#     namespace = "kube-system"
#   }

#   spec {
#     selector {
#       match_labels = {
#         name = "nvidia-driver-installer"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           name = "nvidia-driver-installer"
#         }
#       }

#       spec {
#         node_selector = {
#           "cloud.google.com/gke-accelerator" = "nvidia-tesla-t4"  # ✅ Ensure it runs only on GPU nodes
#         }

#         toleration {
#           key      = "nvidia.com/gpu"
#           operator = "Exists"
#           effect   = "NoSchedule"
#         }

#         host_pid = true  # ✅ Required for installing kernel modules

#         security_context {
#           run_as_user  = 0
#           privileged   = true  # ✅ Required to modify kernel modules
#         }

#         container {
#           name  = "nvidia-driver-installer"
#           image = "nvcr.io/nvidia/driver:535.113.01-ubuntu22.04"  # ✅ Latest stable NVIDIA driver

#           security_context {
#             privileged = true  # ✅ Required for system-level installations
#           }

#           volume_mount {
#             name       = "host-root"
#             mount_path = "/host"
#           }
#         }

#         volume {
#           name = "host-root"
#           host_path {
#             path = "/"  # ✅ Allows the container to install drivers onto the host system
#           }
#         }
#       }
#     }
#   }
# }
