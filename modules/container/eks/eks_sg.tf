// EKS Cluster Security Group
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.environment}-${var.aws_region}-${var.project}-eks-cluster-sg"
  description = "Security group for all traffic within the EKS cluster"
  vpc_id      = var.vpc_id

  ingress {
    description = "EKS management"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "EKS management"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.aws_region}-${var.project}-eks-cluster-sg"
  }
}

// EKS Worker Security Group
resource "aws_security_group" "eks_worker_sg" {
  name        = "${var.environment}-${var.aws_region}-${var.project}-eks-worker-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Intra-node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "Communications with EKS control plane"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.aws_region}-${var.project}-eks-worker-sg"
  }
}

// Istio Security Group
# resource "aws_security_group" "istio_sg" {
#   name = "${var.environment}-${var.aws_region}-${var.project}-eks-istio-sg"
#   description = "Security group for Istio"
#   vpc_id = var.vpc_id

#   ingress {
#       description = "Cluster API - Istio Webhook namespace.sidecar-injector.istio.io"
#       protocol    = "TCP"
#       from_port   = 15017
#       to_port     = 15017
#   }

#   ingress {
#       description = "Cluster API to nodes ports/protocols"
#       protocol    = "TCP"
#       from_port   = 15012
#       to_port     = 15012
#   }
  
#   ingress {
#       description = "Cluster API to nodes ports/protocols"
#       protocol    = "TCP"
#       from_port   = 15021
#       to_port     = 15021
#   }

#   egress {
#     from_port     = 0
#     to_port       = 0
#     protocol      = "-1"
#     cidr_blocks   = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.environment}-${var.aws_region}-${var.project}-eks-istio-sg"
#   } 
# }