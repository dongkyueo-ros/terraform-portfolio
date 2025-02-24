// EKS Cluster IAM Role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster" {
  name               = "eks-${var.environment}-${var.aws_region}-${var.project}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

// Policies attached to EKS Cluster
// 1. EKSClusterPolicy, 2. EKSServicePolicy, 3. EKSVPCResourceController
// Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

// OIDC 제공자 설정 및 서비스 계정 연동
data "tls_certificate" "oidc" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

// 생성한 OIDC를 IAM에 생성
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  count           = var.create_oidc_provider ? 1 : 0  # var.create_oidc_provider는 true 또는 false 값을 가지는 변수
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.oidc.url

  # tags = {
  #   "alpha.eksctl.io/eksctl-version" = "0.173.0"
  #   "alpha.eksctl.io/cluster-name" = "eks-test"
  # }
}