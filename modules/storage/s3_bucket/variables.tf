variable "project" {
  type        = string
  description = "Project Name"
}

variable "environment" {
  type        = string
  description = "Environment name like dev, stg and prd"
}

variable "sites" {
  description = "Map of sites with their domain, subdomains, and bucket names"
  type = map(object({
    bucket_name     = string
  }))
}

variable "aws_region" {
  type = string
}

variable "aws_cloudfront_distribution" {
  type = map(object({
    arn = string
  }))
}