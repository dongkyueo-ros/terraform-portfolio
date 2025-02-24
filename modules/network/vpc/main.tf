// VPC
resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr_block

  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name  = "vpc-${var.environment}-${var.aws_region}-${var.project}"
    Env   = var.environment
  }
}

// Public Subnet
resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnets)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "sbn-${var.environment}-${var.aws_region}${element(["a", "b", "c"], count.index)}-${var.project}-pub-${format("%02d", count.index + 1)}"
    Env  = var.environment
    "kubernetes.io/cluster/eks-${var.environment}-${var.aws_region}-${var.project}-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

// Private Subnet EKS
resource "aws_subnet" "private_subnets_eks" {
  count             = length(var.pv_subnet_cidr_eks)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pv_subnet_cidr_eks[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "sbn-${var.environment}-${var.aws_region}${element(["a", "b", "c"], count.index)}-${var.project}-pri-was-${format("%02d", count.index + 1)}"
    Env  = var.environment
    "kubernetes.io/cluster/eks-${var.environment}-${var.aws_region}-${var.project}-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

// Private Subnet Master
resource "aws_subnet" "private_subnets_master" {
  count             = length(var.pv_subnet_cidr_master)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pv_subnet_cidr_master[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "sbn-${var.environment}-${var.aws_region}${element(["a", "b", "c"], count.index)}-${var.project}-pri-was-${format("%02d", count.index + 4)}"
    Env  = var.environment
    "kubernetes.io/cluster/eks-${var.environment}-${var.aws_region}-${var.project}-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

// Private Subnet DB
resource "aws_subnet" "private_subnets_db" {
  count             = length(var.pv_subnet_cidr_db)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pv_subnet_cidr_db[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "sbn-${var.environment}-${var.aws_region}${element(["a", "b", "c"], count.index)}-${var.project}-pri-db-${format("%02d", count.index + 1)}"
    Env  = var.environment
  }
}

// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-${var.environment}-${var.aws_region}-${var.project}"
    Env = var.environment
  }
}

// Public Routing table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-${var.environment}-${var.aws_region}-${var.project}-pub-01"
    Env  = var.environment
  }
}

// Private Routing table EKS node
resource "aws_route_table" "private_rt_eks" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "rt-${var.environment}-${var.aws_region}-${var.project}-pri-01"
    Env  = var.environment
  }
}

// Private Routing table EKS Master
resource "aws_route_table" "private_rt_master" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "rt-${var.environment}-${var.aws_region}-${var.project}-pri-02"
    Env  = var.environment
  }
}

// Private Routing table DB
resource "aws_route_table" "private_rt_db" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "rt-${var.environment}-${var.aws_region}-${var.project}-pri-03"
    Env  = var.environment
  }
}

// NAT Gateway EIP
resource "aws_eip" "ngw_ip" {
   domain = "vpc"
  
    lifecycle {
        create_before_destroy = true
    }
   tags = {
      Name = "eip-${var.environment}-${var.aws_region}-${var.project}-pub-01"
      Env  = var.environment
  }
}

// NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  # count        = var.environment == "prod" ? length(aws_subnet.public_subnets) : 1
  # allocation_id = aws_eip.ngw_ip[count.index].id
  # subnet_id    = var.environment == "prod" ? aws_subnet.public_subnets[count.index].id : aws_subnet.public_subnets[0].id

  allocation_id = aws_eip.ngw_ip.id
  subnet_id    = aws_subnet.public_subnets[0].id

  tags = {
    Name = "nat-${var.environment}-${var.aws_region}a-${var.project}-pub-01"
  }

  depends_on = [aws_internet_gateway.igw]
}

// Public Routing table Association
resource "aws_route_table_association" "public_rt_association" {
  count = length(aws_subnet.public_subnets)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

// Private Routing table EKS Association
resource "aws_route_table_association" "private_eks_rt_association" {
  count          = length(aws_subnet.private_subnets_eks)
  subnet_id      = aws_subnet.private_subnets_eks[count.index].id
  route_table_id = aws_route_table.private_rt_eks.id
}

// Private Routing table Master Association
resource "aws_route_table_association" "private_master_rt_association" {
  count          = length(aws_subnet.private_subnets_master)
  subnet_id      = aws_subnet.private_subnets_master[count.index].id
  route_table_id = aws_route_table.private_rt_master.id
}

// Private Routing table DB Association
resource "aws_route_table_association" "private_db_rt_association" {
  count          = length(aws_subnet.private_subnets_db)
  subnet_id      = aws_subnet.private_subnets_db[count.index].id
  route_table_id = aws_route_table.private_rt_db.id
}

