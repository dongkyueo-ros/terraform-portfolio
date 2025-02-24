// Worker Node Assume Role
data "aws_iam_policy_document" "workers_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

// Worker Node IAM Role 설정
resource "aws_iam_role" "worker" {
  name               = "eks-${var.environment}-${var.aws_region}-${var.project}-managed-worker-node-role"
  assume_role_policy = data.aws_iam_policy_document.workers_role_assume_role_policy.json
  tags = {
    Name        = "${var.environment}-${var.aws_region}-${var.project}-eks-managed-worker-node-role"
    Environment = "${var.environment}"
  }
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
}

// AutoScaling: 워커 노드 그룹의 자동 스케일링을 설정하려면, 워커 노드가 Auto Scaling 그룹을 관리할 수 있도록 허용하는 정책이 필요할 수 있습니다.
resource "aws_iam_role_policy_attachment" "eks_cluster_autoscaler_attachment" {
  role       = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.eks_cluster_autoscaler.arn
}

// External DNS 사용을 위해 추가
resource "aws_iam_role_policy_attachment" "eks-AmazonRoute53FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
  role        = aws_iam_role.worker.name
}

// SSM Access
resource "aws_iam_role_policy_attachment" "eks_AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.worker.name
}
