resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = var.monitoring_namespace
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "56.6.0"  # Check for latest version
  values = [
    <<EOF
    nodeExporter:
      hostPort: 9101
      service:
        port: 9101
        targetPort: 9101

    prometheus:
      service:
        type: ClusterIP
      prometheusSpec:
        priorityClassName: ""

    alertmanager:
      enabled: true

    grafana:
      enabled: true
    EOF
  ]
  create_namespace = true

  set {
    name  = "prometheusOperator.createCustomResource"
    value = "true"
  }
}
resource "kubernetes_manifest" "dcgm_servicemonitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "dcgm-exporter"
      namespace = var.monitoring_namespace
      labels = {
        release = "prometheus"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "nvidia-dcgm-exporter" 
        }
      }
      namespaceSelector = {
        matchNames = ["gpu-operator"]
      }
      endpoints = [{
        port     = "gpu-metrics"
        interval = "30s"
      }]
    }
  }
  depends_on = [helm_release.prometheus]
}

resource "kubernetes_service" "grafana" {
  metadata {
    name      = "prometheus-grafana"
    namespace = "observability"  # Adjust based on namespace
  }

  spec {
    selector = {
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/instance" = "prometheus"
    }

    port {
      port        = 80      # External LB Port
      target_port = 3000    # Grafana's Internal Port
    }

    load_balancer_ip = google_compute_address.grafana_static_ip.address
    type = "LoadBalancer"
  }
}

resource "google_compute_address" "grafana_static_ip" {
  name   = "grafana-static-ip"
  region = "southamerica-east1"  # Change to match GKE region
  project = "ai-research-e44f"
}
