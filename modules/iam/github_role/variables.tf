variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "website_bucket_release" {
  type = map(object({
    arn = string
  }))
}

variable "aws_cloudfront_distribution" {
  type = map(object({
    arn = string
  }))
}

variable "sites" {
  type = map(object({
    bucket_name = string
    github_repo = string
  }))
}

variable "github_organizations" {
  type = string
}

variable "github_branch" {
  type = list(string)
}