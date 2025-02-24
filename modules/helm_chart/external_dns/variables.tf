variable "aws_account_id" {
  description = "account id number"
}

variable "external_dns_version" {
  description = "External-dns Helm chart version to deploy. 3.0.0 is the minimum version for this function"
  type        = string
}

variable "external_dns_chart_log_level" {
  description = "External-dns Helm chart log leve. Possible values are: panic, debug, info, warn, error, fatal"
  type        = string
}

variable "external_dns_zoneType" {
  description = "External-dns Helm chart AWS DNS zone type (public, private or empty for both)"
  type        = string
}

variable "external_dns_domain_filters" {
  description = "External-dns Domain filters."
  type        = list(string)
}

variable "cluster_name" {
  description = "cluster_name"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "cluster_endpoint" {
  description = "cluster_endpoint"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "cluster_certificate_authority_data"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "cluster_oidc_issuer_url"
  type        = string
}

variable "aws_lb_controller_release" {
  type        = string
  description = "Name of the AWS Load Balancer Controller"
}