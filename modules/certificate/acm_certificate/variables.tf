variable "sites" {
  description = "Map of sites with their domain, subdomains, and bucket names"
  type = map(object({
    domain_name     = string
  }))
}
variable "region" {
  type = string
}

variable "acm_certificate_domain_name" {
  type = string
}