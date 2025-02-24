output "metrics_server_release" {
  value       = helm_release.metrics_server.name
}

output "prometheus_release" {
  description = "The name of the Helm release."
  value       = helm_release.prometheus.name
}