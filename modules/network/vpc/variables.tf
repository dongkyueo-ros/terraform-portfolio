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
variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block of the VPC"
}

variable "public_subnets" {
  type        = list
}

variable "pv_subnet_cidr_eks" {
  type        = list
}

variable "pv_subnet_cidr_master" {
  type        = list
}

variable "pv_subnet_cidr_db" {
  type        = list
}

variable "azs" {
  type        = list
}