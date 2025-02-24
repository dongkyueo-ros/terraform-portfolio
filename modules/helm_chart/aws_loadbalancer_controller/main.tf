locals {
  lb_controller_iam_role_name        = var.lb_ctrl_iam_role_name
  lb_controller_service_account_name = var.lb_ctrl_svc_account_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

module "lb_controller_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role = true

  role_name        = var.lb_ctrl_iam_role_name
  role_path        = "/"
  role_description = "Used by AWS Load Balancer Controller for EKS"

  #role_permissions_boundary_arn = ""

  provider_url = replace(var.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:kube-system:${var.lb_ctrl_svc_account_name}"
  ]
  oidc_fully_qualified_audiences = [
    "sts.amazonaws.com"
  ]
  tags = {
    Name  = "${var.environment}-${var.aws_region}-${var.project}-alb-ctrl-role" 
  }
}

# IAM 정책 적용
data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.6.0/docs/install/iam_policy.json"
}

resource "aws_iam_role_policy" "controller" {
  name_prefix = "AWSLoadBalancerControllerIAMPolicy"
  policy      = data.http.iam_policy.response_body
  role        = module.lb_controller_role.iam_role_name
}

resource "helm_release" "aws_lb_controller" {
  name              = "aws-load-balancer-controller"
  chart             = "aws-load-balancer-controller"
  repository        = "https://aws.github.io/eks-charts"
  version           =  var.lb_controller_chart_version
  namespace         = "kube-system"
  cleanup_on_fail   = true
  force_update      = false
  wait              = true

  dynamic "set" {
    for_each = {
      "clusterName"           = var.cluster_name
      "serviceAccount.create" = "true"
      "serviceAccount.name"   = local.lb_controller_service_account_name
      "region"                = var.region
      "vpcId"                 = var.vpc_id
      "hostNetwork"           = "true"
      "image.repository"      = "602401143452.dkr.ecr.${var.region}.amazonaws.com/amazon/aws-load-balancer-controller"
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.lb_controller_role.iam_role_arn
    }
    content {
      name  = set.key
      value = set.value
    }
  }
  depends_on = [var.prometheus_release]
}