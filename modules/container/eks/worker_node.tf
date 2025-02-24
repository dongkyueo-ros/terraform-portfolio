// EKS Worker Node
resource "aws_eks_node_group" "worker" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "eks-${var.environment}-${var.aws_region}-${var.project}-worker-node"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = [var.pv_subnet_eks_ids[0], var.pv_subnet_eks_ids[1], var.pv_subnet_eks_ids[2]]

  // Worker Settings
  for_each = var.workers_config

  instance_types = var.workers_config[each.key].instance_types
  disk_size      = var.workers_config[each.key].disk_size
  ami_type       = var.workers_config[each.key].ami_type
  capacity_type  = var.workers_config[each.key].capacity_type

  scaling_config {
    desired_size = var.workers_config[each.key].desired_size
    min_size     = var.workers_config[each.key].min_size
    max_size     = var.workers_config[each.key].max_size
  }

  remote_access {
    source_security_group_ids = [var.bastion_sg_id]
    ec2_ssh_key               = var.ec2_ssh_key
  }

  tags = {
    Name        = "eks-${var.environment}-${var.aws_region}-${var.project}-worker-node"
    Environment = "${var.environment}"
    Owner       = var.project
    Role        = "nodegroup"
  }

  // Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  // Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_cluster_autoscaler_attachment,
    aws_iam_role_policy_attachment.eks-AmazonRoute53FullAccess
  ]
}

# resource "aws_autoscaling_group_tag" "node_group" {
#   for_each = toset(
#     [for asg in flatten(
#       [for resource in aws_eks_node_group.worker : resource.resources[0].autoscaling_groups]
#     ) : asg.name ]
#   )

#   autoscaling_group_name = each.value

#   tag {
#     key   = "Name"
#     value = "eks-${var.environment}-${var.aws_region}-${var.project}-worker-node"
#     propagate_at_launch = true
#   }

#   depends_on = [aws_eks_node_group.worker]
# }
