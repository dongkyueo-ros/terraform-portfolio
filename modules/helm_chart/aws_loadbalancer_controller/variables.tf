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

variable "lb_ctrl_iam_role_name" {
  type        = string
  description = "lb_ctrl_iam_role_name"
}

variable "lb_ctrl_svc_account_name" {
  type        = string
  description = "lb_ctrl_svc_account_name"
}

variable "cluster_name" {
  type        = string
  description = "cluster_name"
}

variable "region" {
  type        = string
  description = "region"
}

variable "cluster_id" {
  type        = string
  description = "cluster_id"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cluster_endpoint" {
  type        = string
  description = "cluster_endpoint"
}

variable "cluster_certificate_authority_data" {
  type        = string
  description = "cluster_certificate_authority_data"
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "cluster_oidc_issuer_url"
}

variable "lb_controller_chart_version" {
  type = string
}

variable "prometheus_release" {
  type = string
}