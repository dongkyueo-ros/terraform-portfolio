// Public Subnet Network ACL
resource "aws_network_acl" "public_nacl" {
  vpc_id = var.vpc_id

  tags = {
    Name = "nacl-${var.environment}-${var.aws_region}-${var.project}-pub"
  }
}

// Private Subnet Network ACL EKS
resource "aws_network_acl" "private_eks_nacl" {
  vpc_id = var.vpc_id

  tags = {
    Name = "nacl-${var.environment}-${var.aws_region}-${var.project}-eks-pri"
  }
}

// Private Subnet Network ACL RDS
resource "aws_network_acl" "private_db_nacl" {
  vpc_id = var.vpc_id

  tags = {
    Name = "nacl-${var.environment}-${var.aws_region}-${var.project}-db-pri"
  }
}


// Public NACL
# 퍼블릭 서브넷용 Network ACL 규칙
# SSH (22) 트래픽 허용
resource "aws_network_acl_rule" "public_ssh_rule" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# HTTP (80) 트래픽 허용
resource "aws_network_acl_rule" "public_http_rule" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 200
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# HTTPS (443) 트래픽 허용
resource "aws_network_acl_rule" "public_https_rule" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 300
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# AWS Ephemeral 포트 트래픽 허용 (1024 ~ 65535) to (1024 ~ 50000)
resource "aws_network_acl_rule" "public_ephemeral_ports_rule" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 500
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_http_egress_rule" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  rule_action    = "allow"
  egress         = true  # 아웃바운드 규칙 설정
  protocol       = "-1" # 모든 프로토콜
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}


// Private EKS NACL
# 프라이빗 EKS 서브넷용 Network ACL 규칙
# SSH (22) 트래픽 허용
resource "aws_network_acl_rule" "private_eks_ssh_rule" {
  network_acl_id = aws_network_acl.private_eks_nacl.id
  rule_number    = 100
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# HTTP (80) 트래픽 허용
resource "aws_network_acl_rule" "private_eks_http_rule" {
  count         = var.environment == "dev" ? 1 : 0
  network_acl_id = aws_network_acl.private_eks_nacl.id
  rule_number    = 200
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# HTTPS (443) 트래픽 허용
resource "aws_network_acl_rule" "private_eks_https_rule" {
  count         = var.environment == "dev" ? 1 : 0
  network_acl_id = aws_network_acl.private_eks_nacl.id
  rule_number    = 300
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# AWS Ephemeral 포트 트래픽 허용 (1024 ~ 65535) to (1024 ~ 50000)
resource "aws_network_acl_rule" "private_eks_ephemeral_ports_rule" {
  network_acl_id = aws_network_acl.private_eks_nacl.id
  rule_number    = 500
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_eks_http_egress_rule" {
  network_acl_id = aws_network_acl.private_eks_nacl.id
  rule_number    = 100
  rule_action    = "allow"
  egress         = true  # 아웃바운드 규칙 설정
  protocol       = "-1" # 모든 프로토콜
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# # HTTPS 아웃바운드 트래픽 허용 (443 포트)
# resource "aws_network_acl_rule" "private_eks_https_egress_rule" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 200
#   rule_action    = "allow"
#   egress         = true  # 아웃바운드 규칙 설정
#   protocol       = "tcp"
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 443
#   to_port        = 443
# }

// Private DB NACL
# 프라이빗 DB 서브넷용 Network ACL 규칙
# SSH (22) 트래픽 허용
resource "aws_network_acl_rule" "private_db_ssh_rule" {
  network_acl_id = aws_network_acl.private_db_nacl.id
  rule_number    = 100
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# HTTP (80) 트래픽 허용
resource "aws_network_acl_rule" "private_db_http_rule" {
  count         = var.environment == "dev" ? 1 : 0
  network_acl_id = aws_network_acl.private_db_nacl.id
  rule_number    = 200
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# HTTPS (443) 트래픽 허용
resource "aws_network_acl_rule" "private_db_https_rule" {
  count         = var.environment == "dev" ? 1 : 0
  network_acl_id = aws_network_acl.private_db_nacl.id
  rule_number    = 300
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# AWS Ephemeral 포트 트래픽 허용 (1024 ~ 65535) to (1024 ~ 50000)
resource "aws_network_acl_rule" "private_db_ephemeral_ports_rule" {
  network_acl_id = aws_network_acl.private_db_nacl.id
  rule_number    = 500
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

# 그 외 모든 인바운드 트래픽 거부
resource "aws_network_acl_rule" "private_db_deny_rule" {
  network_acl_id = aws_network_acl.private_db_nacl.id
  rule_number    = 999
  rule_action    = "deny"
  egress         = false
  protocol       = "-1" # 모든 프로토콜
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# 아웃바운드 모든 트래픽 허용
resource "aws_network_acl_rule" "private_db_http_egress_rule" {
  network_acl_id = aws_network_acl.private_db_nacl.id
  rule_number    = 100
  rule_action    = "allow"
  egress         = true  # 아웃바운드 규칙 설정
  protocol       = "-1" # 모든 프로토콜
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# # HTTPS 아웃바운드 트래픽 허용 (443 포트)
# resource "aws_network_acl_rule" "private_db_https_egress_rule" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 200
#   rule_action    = "allow"
#   egress         = true  # 아웃바운드 규칙 설정
#   protocol       = "tcp"
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 443
#   to_port        = 443
# }


// Public Subnet Network ACL 연결
resource "aws_network_acl_association" "public_nacl_association" {
  count         = length(var.pb_subnets)
  subnet_id     = var.pb_subnets[count.index].id
  network_acl_id = aws_network_acl.public_nacl.id
}

// Private EKS Subnet Network ACL 연결
resource "aws_network_acl_association" "private_eks_nacl_association_eks" {
  count          = length(var.pv_subnets_eks)
  subnet_id      = var.pv_subnets_eks[count.index].id
  network_acl_id = aws_network_acl.private_eks_nacl.id
}

// Private EKS Master Subnet Network ACL 연결
resource "aws_network_acl_association" "private_eks_nacl_association_master" {
  count          = length(var.pv_subnets_master)
  subnet_id      = var.pv_subnets_master[count.index].id
  network_acl_id = aws_network_acl.private_eks_nacl.id
}

// Private DB Subnet Network ACL 연결
resource "aws_network_acl_association" "private_db_nacl_association" {
  count         = length(var.pv_subnets_db)
  subnet_id     = var.pv_subnets_db[count.index].id
  network_acl_id = aws_network_acl.private_db_nacl.id
}