variable "project" {
  type        = string
  description = "Project Name"
}

variable "environment" {
  type        = string
  description = "Environment name like dev, stg and prd"
}

variable "region" {
  type        = string
  description = "region"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "cluster_name" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "cluster_workernode_release" {
  type = string
}

variable "ssh_private_key" {
  type = string
  default = "eks_bastion_api.pem"
}

variable "username" {
  type = string
  default = "ubuntu"
}

variable "bastion_public_eip" {
  type = string
}

variable "bastion_id" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}