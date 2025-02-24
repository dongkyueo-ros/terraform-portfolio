variable "cluster_name" {
  type        = string
  description = "Name of the Metrics Server"
}

variable "cluster_id" {
  type        = string
  description = "cluster_id"
}

variable "cluster_endpoint" {
  type        = string
  description = "cluster_endpoint"
}

variable "cluster_certificate_authority_data" {
  type        = string
  description = "cluster_certificate_authority_data"
}

variable "metrics_server_chart_version" {
  type        = string
  description = "metric-server chart version"
}

variable "calico_release" {
  type = string
}