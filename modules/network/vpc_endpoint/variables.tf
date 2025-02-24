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

variable "region" {
  type        = string
  description = "aws_region"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "pv_subnet_cidr_eks" {
  type        = list
}

# variable "pb_subnet_ids" {
#   type        = list
#   description = "Public subnet's"
# }

variable "pv_subnet_eks_ids" {
  type        = list
  description = "Private subnet's eks ids"
}
variable "pv_subnet_master_ids" {
  type        = list
  description = "Private subnet's control plane"
}