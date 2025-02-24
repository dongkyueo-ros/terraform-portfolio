variable "sites" {
  description = "Map of sites with their domain, subdomains, and bucket names"
  type = map(object({
    domain_name     = string
    subdomain_name  = optional(string)
    bucket_name     = string
  }))
}

variable "aws_cloudfront_distribution" {
  type = map(object({
    domain_name     = string
    hosted_zone_id  = string
  }))
}