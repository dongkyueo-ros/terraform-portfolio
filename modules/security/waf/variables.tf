variable "project" {
  type        = string
  description = "Project Name"
}

variable "environment" {
  type        = string
  description = "Environment name like dev, stg and prd"
}

variable "region" {
  type  = string
}

variable "aws_primary_region" {
  type = string
}

variable "waf_cdn" {
  type = map(any)
}

variable "waf_alb" {
  type = map(any)
}