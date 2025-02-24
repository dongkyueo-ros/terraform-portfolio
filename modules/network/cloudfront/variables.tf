variable "environment" {
  type = string
}
variable "sites" {
  description = "Map of sites with their domain, subdomains, and bucket names"
  type = map(object({
    domain_name     = string
    subdomain_name  = optional(string)
    bucket_name     = string
    aliases         = list(string)
    use_function    = bool
  }))
}

variable "logs_bucket_name" {
  description = "The name of the S3 bucket for CloudFront logs"
  type        = string
}

variable "logs_bucket_release" {
  type = string
}

variable "website_bucket_release" {
  type = map(object({
    id = string
    bucket_regional_domain_name = string
  }))
}

variable "ssl_certificate_virginia" {
  type = map(object({
    arn = string
  }))
}

# variable "acm_certificate_ssl_certificate_virginia_arn" {
#   type = string
# }

# variable "virginia_acm_certificate_validation_arn" {
#   type = string
# }