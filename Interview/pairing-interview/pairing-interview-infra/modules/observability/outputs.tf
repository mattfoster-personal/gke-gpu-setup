output "prometheus_operator_status" {
  description = "Prometheus Operator status"
  value       = helm_release.prometheus.status
}

output "grafana_static_ip" {
  value = google_compute_address.grafana_static_ip.address
}