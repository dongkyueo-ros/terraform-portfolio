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

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "pb_subnets" {
  type        = list
  description = "public subnet list"
}

variable "pv_subnets_eks" {
  type        = list
  description = "private eks subnet list"
}

variable "pv_subnets_master" {
  type        = list
  description = "private db subnet list"
}

variable "pv_subnets_db" {
  type        = list
  description = "private db subnet list"
}

