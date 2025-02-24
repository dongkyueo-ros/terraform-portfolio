variable "project" {
  type        = string
  description = "Project Name"
}

variable "environment" {
  type        = string
  description = "Environment name like dev, stg and prd"
}

variable "aws_region" {
  type = string
}

variable "logs_bucket_name" {
  description = "The name of the S3 bucket for CloudFront logs"
  type        = string
}

variable "aws_cloudfront_distribution" {
  type = map(object({
    arn = string
  }))
}