##############################
# These VPC endpoints allow the nodes to privately connect to ECR/s3. 
# It doesn’t require the nodes to use NAT Gateways and then reduce the cost of them.
##############################
resource "aws_security_group" "endpoint_ecr" {
  name   = "endpoint-ecr"
  vpc_id = var.vpc_id
}

# resource "aws_security_group_rule" "endpoint_ecr_443" {
#   security_group_id = aws_security_group.endpoint_ecr.id
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = var.pv_subnet_cidr_eks
# }


# ##############################
# # VPC Endpoint (ecr.dkr)
# ##############################
# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id              = var.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   security_group_ids = [aws_security_group.endpoint_ecr.id]
#   subnet_ids         = var.pv_subnet_eks_ids

#   tags = {
#     "Name" = "${var.project}-${var.environment}-ecr-dkr"
#   }
# }

# ##############################
# # VPC Endpoint (ecr.api)
# ##############################
# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id              = var.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   security_group_ids = [aws_security_group.endpoint_ecr.id]
#   subnet_ids         = var.pv_subnet_eks_ids

#   tags = {
#     "Name" = "${var.project}-${var.environment}-ecr-api"
#   }
# }

// VPC Endpoint (s3)
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  policy = data.aws_iam_policy_document.vpc_endpoint_policy.json

  tags = {
    "Name" = "vpe-${var.environment}-${var.aws_region}-${var.project}-s3"
  }
}


# // VPC Endpoint (STS)
# resource "aws_security_group" "ep_sts_sg" {
#   name        = "endpoint-sts-sg"
#   description = "Security group for HTTP and HTTPS traffic to STS"
#   vpc_id      = var.vpc_id

#   ingress {
#     description = "Allow HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow HTTPS"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # 모든 아웃바운드 트래픽을 허용
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "endpoint-sts-sg"
#   }
# }

# resource "aws_vpc_endpoint" "ep_sts" {
#   vpc_id              = var.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.sts"
#   vpc_endpoint_type   = "Interface"  # STS는 Interface 타입의 엔드포인트를 사용합니다.
#   private_dns_enabled = true

#   security_group_ids = [aws_security_group.ep_sts_sg.id]
#   subnet_ids = [var.pv_subnet_eks_ids[0], var.pv_subnet_eks_ids[1], var.pv_subnet_eks_ids[2]]

#   tags = {
#     "Name" = "vpe-${var.project}-${var.environment}-${var.region}-sts"
#   }
#   depends_on = [aws_security_group.ep_sts_sg]
# }