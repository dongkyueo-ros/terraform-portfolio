// Terraform version, Terraform Cloud
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, ~> 5.0"
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
  }

  cloud {
    organization = "<terraform_organization>"
    workspaces {
      name = "kor_prod"
    }
  }
}

// AWS Configuration
provider "aws" {
  region = "ap-northeast-2"
}

// VPC
module "vpc" {
  source  = "../../modules/network/vpc"

  project                 = local.project
  environment             = local.environment
  aws_region              = local.aws_region 
  vpc_cidr_block          = var.vpc_cidr_block
  public_subnets          = var.public_subnets
  pv_subnet_cidr_eks      = var.private_subnets_eks
  pv_subnet_cidr_master   = var.private_subnets_master
  pv_subnet_cidr_db       = var.private_subnets_db
  azs                     = var.azs
}

// Network ACL
module "nacl" {
  source  = "../../modules/network/nacl"
  
  project           = local.project
  environment       = local.environment
  aws_region        = local.aws_region 
  vpc_id            = module.vpc.vpc_id
  pb_subnets        = module.vpc.pb_subnets
  pv_subnets_eks    = module.vpc.pv_subnets_eks
  pv_subnets_db     = module.vpc.pv_subnets_db
  pv_subnets_master = module.vpc.pv_subnets_master
}

// EKS
module "eks" {
  source  = "../../modules/container/eks"

  project               = local.project
  environment           = local.environment
  aws_region            = local.aws_region
  aws_account_id        = var.aws_account_id
  vpc_id                = module.vpc.vpc_id
  pv_subnet_eks_ids     = module.vpc.pv_subnet_eks_ids
  pv_subnet_master_ids  = module.vpc.pv_subnet_master_ids
  pv_subnet_db_ids      = module.vpc.pv_subnet_db_ids
  eks_cluster_version   = var.eks_version
  workers_config        = var.workers_config
  ec2_ssh_key           = var.ec2_ssh_key
  bastion_sg_id         = module.ec2.bastion_sg_id
}

// EC2 Bastion
module "ec2" {
  source = "../../modules/computing/ec2"

  project                     = local.project
  environment                 = local.environment
  region                      = local.region
  aws_region                  = local.aws_region
  vpc_id                      = module.vpc.vpc_id
  pb_subnet_ids               = module.vpc.pb_subnet_ids
  cluster_name                = module.eks.cluster_name
  #ec2_instances               = local.ec2.ec2_instances
  aws_account_id              = var.aws_account_id
  company_ip_ranges           = var.company_ip_ranges
  cluster_workernode_release  = module.eks.cluster_workernode_release
}

// VPC Endpoint
module "vpc_endpoint" {
  source          = "../../modules/network/vpc_endpoint"
  
  project              = local.project
  environment          = local.environment
  region               = local.region
  aws_region           = local.aws_region
  vpc_id               = module.vpc.vpc_id
  pv_subnet_cidr_eks   = var.private_subnets_eks
  # pb_subnet_ids = module.vpc.pb_subnet_ids
  pv_subnet_eks_ids    = module.vpc.pv_subnet_eks_ids
  pv_subnet_master_ids = module.vpc.pv_subnet_master_ids
}

// ACM Cetificate
module "acm_certificate" {
  source  = "../../modules/certificate/acm_certificate"

  sites                         = var.sites
  region                        = local.region
  acm_certificate_domain_name   = var.acm_certificate_domain_name
}

// S3 Bucket
module "s3_bucket" {
  source = "../../modules/storage/s3_bucket"

  project                     = local.project
  environment                 = local.environment
  sites                       = var.sites
  aws_region                  = local.region
  aws_cloudfront_distribution = module.cloudfront.aws_cloudfront_distribution 
}

// S3 Logs Bucket
module "log_buket" {
  source = "../../modules/storage/log_bucket"

  project                     = local.project
  environment                 = local.environment
  aws_region                  = local.region
  logs_bucket_name            = var.logs_bucket_name
  aws_cloudfront_distribution = module.cloudfront.aws_cloudfront_distribution
}

// CloudFront
module "cloudfront" {
  source = "../../modules/network/cloudfront"

  environment               = local.environment
  sites                     = var.sites
  logs_bucket_name          = module.log_buket.logs_bucket_name
  logs_bucket_release       = module.log_buket.logs_bucket_release
  website_bucket_release    = module.s3_bucket.website_bucket_release
  #acm_certificate_ssl_certificate_virginia_arn  = module.acm_certificate.acm_certificate_ssl_certificate_virginia_arn
  ssl_certificate_virginia  = module.acm_certificate.ssl_certificate_virginia
}

// Route53
module "route53" {
  source = "../../modules/network/route53"
  
  sites                       = var.sites
  aws_cloudfront_distribution = module.cloudfront.aws_cloudfront_distribution
}

// Ansible
module "ansible" {
  source = "../../modules/ansible"

  project                     = local.project
  environment                 = local.environment
  region                      = local.region
  vpc_id                      = module.vpc.vpc_id
  cluster_name                = module.eks.cluster_name
  aws_account_id              = var.aws_account_id
  cluster_workernode_release  = module.eks.cluster_workernode_release
  bastion_public_eip          = module.ec2.bastion_public_eip
  bastion_id                  = module.ec2.bastion_id
  hosted_zone_id              = module.route53.hosted_zone_id
}

// GitHub Role OIDC
module "github_role" {
  source = "../../modules/iam/github_role"

  project                     = local.project
  environment                 = local.environment
  aws_region                  = local.aws_region
  sites                       = var.sites
  aws_cloudfront_distribution = module.cloudfront.aws_cloudfront_distribution
  website_bucket_release      = module.s3_bucket.website_bucket_release
  github_organizations        = local.github_organizations
  github_branch               = local.github_branch
}