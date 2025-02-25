variable "aws_account_id" {
  description = "AWS Account ID"
}

// VPC variables
variable "vpc_cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets_eks" {
  type = list(string)
}

variable "private_subnets_master" {
  type = list(string)
}

variable "private_subnets_db" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

// EKS variables
variable "eks_version" {
  type = string
}

variable "workers_config" {
  type = map(any)
}

variable "ec2_ssh_key" {
  type = string
}

//EC2 Bastion
variable "company_ip_ranges" {
  type = list(string)
}

// S3, ACM
variable "sites" {
  type = map(object({
    domain_name    = string
    subdomain_name = string
    bucket_name    = string
    aliases        = list(string)
    use_function   = bool
    github_repo    = string
    github_branch  = list(string)
  }))
}

variable "acm_certificate_domain_name" {
  type = string
}

variable "logs_bucket_name" {
  type = string
}