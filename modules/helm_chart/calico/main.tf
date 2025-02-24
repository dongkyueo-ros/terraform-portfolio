provider "helm" {
  kubernetes {
    host    = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

// Calico  
resource "helm_release" "calico" {
  name              = "calico"
  chart             = "tigera-operator"
  repository        = "https://projectcalico.docs.tigera.io/charts" #"https://docs.tigera.io/calico/charts"
  namespace         = "tigera-operator" 
  #version           = "0.2.0"
  cleanup_on_fail   = true
  force_update      = true
  wait              = true

#   set {
#     name = "calico_backend"
#     value = "bird"
#   }

  values = [
    "${templatefile("${path.module}/templates/values.yaml.tpl",
      {
        "calico_version"         = "v3.8.1",
        "calico_image"           = "quay.io/calico/node",
        "typha_image"            = "quay.io/calico/typha",
        "service_account_create" = "ture",
      })
    }"
  ]
  depends_on = [var.aws_auth_configmap_name]
}
