locals {
  oidc_url = replace(var.cluster_oidc_issuer_url, "https://", "")
}

// Helm Release External DNS
resource "helm_release" "external_dns" {
  name       = "external-dns"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = "kube-system"
  version    = var.external_dns_version
  wait       = true

  dynamic "set" {
    for_each = {
      "name"                            = "${var.cluster_name}-external-dns"
      "region"                          = var.region
      "serviceAccount.create"           = "true"
      "serviceAccount.name"             = "external-dns"
      "rbac.create"                     = "true"
      "rbac.pspEnabled"                 = "true"
      "policy"                          = "sync"
      "logLevel"                        = var.external_dns_chart_log_level
      "source"                          = "{ingress,service}"
      "domainFilters"                   = "{${join(",", var.external_dns_domain_filters)}}"
      "aws.zoneType"                    = var.external_dns_zoneType
      "automount_service_account_token" = "true"
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = aws_iam_role.external_dns.arn
    }
    content {
      name  = set.key
      value = set.value
    }
  }
  depends_on = [var.aws_lb_controller_release]
}