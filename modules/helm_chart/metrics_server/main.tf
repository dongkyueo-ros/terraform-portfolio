// Metrics-Server
resource "helm_release" "metrics_server" {
  name              = "metrics-server"
  repository        = "https://kubernetes-sigs.github.io/metrics-server/"
  chart             = "metrics-server"
  namespace         = "kube-system"
  version           = var.metrics_server_chart_version
  cleanup_on_fail   = true
  force_update      = false
  wait              = true

  set {
    name  = "apiService.create"
    value = "true"
  }
  depends_on = [var.calico_release]
}
