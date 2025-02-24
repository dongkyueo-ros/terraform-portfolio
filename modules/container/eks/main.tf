locals {
  iam_role_policy_prefix = "arn:aws:iam::${var.aws_account_id}:policy"
}

resource "aws_eks_cluster" "cluster" {
  name                      = "eks-${var.environment}-${var.aws_region}-${var.project}-cluster"
  role_arn                  = aws_iam_role.cluster.arn
  version                   = var.eks_cluster_version
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids              = flatten([var.pv_subnet_master_ids[0], var.pv_subnet_master_ids[1], var.pv_subnet_master_ids[2]])
    security_group_ids      = [aws_security_group.eks_cluster_sg.id, aws_security_group.eks_worker_sg.id, aws_security_group.eks_worker_sg.id]
    endpoint_private_access = "true"
    endpoint_public_access  = "false"  // false API Server Endpoint Private
  }

  access_config {
    authentication_mode                         = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "10.100.0.0/16"
  }

  tags = {
    Name        = "eks-${var.environment}-${var.aws_region}-${var.project}-cluster"
    Environment = var.environment
    Owner       = var.project
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.cluster
  ]
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/eks-${var.environment}-${var.aws_region}-${var.project}-cluster/cluster"
  retention_in_days = 7

  tags = {
    Name        = "eks-${var.environment}-${var.aws_region}-${var.project}-cluster"
    Environment = var.environment
    Owner       = var.project
  }
}

# ##################################################
# # EKS IAM
# ##################################################

# ## EC2 Worker ###
# module "iam_policy_autoscaling" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-policy"

#   name = "${var.project}-${var.environment}-eks-cluster-autoscaler"
#   path = "/"
#   description = "Autoscaling policy for cluster ${var.project}-${var.environment}-eks-01"

#   policy      = data.aws_iam_policy_document.worker_autoscaling.json
#   tags = {
#     Name = "${var.project}-${var.environment}-iam-policy-autoscaling"
#   }
# }

# data "aws_iam_policy_document" "worker_autoscaling" {
#   statement {
#     sid    = "eksWorkerAutoscalingAll"
#     effect = "Allow"

#     actions = [
#       "autoscaling:DescribeAutoScalingGroups",
#       "autoscaling:DescribeAutoScalingInstances",
#       "autoscaling:DescribeLaunchConfigurations",
#       "autoscaling:DescribeTags",
#       "ec2:DescribeLaunchTemplateVersions",
#     ]

#     resources = ["*"]
#   }

#   statement {
#     sid    = "eksWorkerAutoscalingOwn"
#     effect = "Allow"

#     actions = [
#       "autoscaling:SetDesiredCapacity",
#       "autoscaling:TerminateInstanceInAutoScalingGroup",
#       "autoscaling:UpdateAutoScalingGroup",
#     ]

#     resources = ["*"]

#     condition {
#       test     = "StringEquals"
#       variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${var.project}-${var.environment}-eks-01"
#       values   = ["owned"]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
#       values   = ["true"]
#     }
#   }
# }


# data "aws_iam_policy" "ebs_csi_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
# }

# module "irsa-ebs-csi" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version = "4.7.0"

#   create_role                   = true
#   role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
#   provider_url                  = module.eks.oidc_provider
#   role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
#   oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
# }

# resource "aws_eks_addon" "ebs-csi" {
#   cluster_name             = module.eks.cluster_name
#   addon_name               = "aws-ebs-csi-driver"
#   addon_version            = "v1.20.0-eksbuild.1"
#   service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
#   tags = {
#     "eks_addon" = "ebs-csi"
#     "terraform" = "true"
#   }
# }