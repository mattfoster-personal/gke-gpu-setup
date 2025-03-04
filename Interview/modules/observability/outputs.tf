output "prometheus_operator_status" {
  description = "Prometheus Operator status"
  value       = helm_release.prometheus_operator.status
}