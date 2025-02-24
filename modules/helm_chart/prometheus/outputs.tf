output "prometheus_release" {
  description = "The name of the Helm release."
  value       = helm_release.prometheus.name
}