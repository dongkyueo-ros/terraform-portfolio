variable "project" {
  type        = string
  description = "Project Name"
}

variable "environment" {
  type        = string
  description = "Environment name like dev, stg and prd"
}

variable "aws_region" {
  type        = string
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "pv_subnet_eks_ids" {
  type        = list
  description = "Private subnet's eks"
}

variable "pv_subnet_master_ids" {
  type        = list
  description = "Private subnet's control plane"
}

variable "pv_subnet_db_ids" {
  type        = list
  description = "Private subnet's db"
}

variable "eks_cluster_version" {
  type        = string
  description = "EKS cluster version"
}

variable "workers_config" {
  type        = map(any)
  description = "workers config"
}

variable "ec2_ssh_key" {
  description = "The EC2 SSH key name to allow remote access to the worker nodes"
  type        = string
}

variable "create_oidc_provider" {
  description = "A boolean flag to control whether the OIDC provider should be created."
  type        = bool
  default     = true  # 기본적으로 OIDC 공급자를 생성하도록 설정
}

variable "bastion_sg_id" {
  type        = string
}