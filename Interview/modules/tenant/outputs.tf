output "namespace" {
  description = "The namespace assigned to the tenant"
  value       = kubernetes_namespace.tenant.metadata[0].name
}
