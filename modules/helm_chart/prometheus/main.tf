
// Prometheus
resource "helm_release" "prometheus" {
  name              = "prometheus"
  repository        = "https://prometheus-community.github.io/helm-charts" #"https://charts.bitnami.com/bitnami" 
  chart             = "kube-prometheus-stack"
  namespace         = "istio-system"
  version           = var.prometheus_chart_version
  create_namespace  = true
  cleanup_on_fail   = true
  force_update      = false
  wait              = true
  timeout           = 600 

  # values = [
  #   templatefile("${path.module}/templates/prometheus_values.yaml.tpl", {})
  # ]

  depends_on = [helm_release.metrics_server]
}