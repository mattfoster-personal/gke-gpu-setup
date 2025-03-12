# resource "kubernetes_service" "grafana" {
#   metadata {
#     name      = "grafana"
#     namespace = "monitoring"  # Adjust based on your namespace
#   }

#   spec {
#     selector = {
#       app = "grafana"
#     }

#     port {
#       port        = 80      # External LB Port
#       target_port = 3000    # Grafana's Internal Port
#     }

#     type = "LoadBalancer"
#   }
# }

# resource "google_compute_address" "grafana_static_ip" {
#   name   = "grafana-static-ip"
#   region = "southamerica-east1-c"  # Change to match your GKE region
# }