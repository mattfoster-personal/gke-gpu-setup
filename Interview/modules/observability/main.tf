resource "helm_release" "prometheus_operator" {
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