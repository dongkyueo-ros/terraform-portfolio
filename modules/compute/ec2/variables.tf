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

variable "region" {
  type        = string
  description = "region"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "pb_subnet_ids" {
  type        = list(string)
  description = "Public subnet's"
}

variable "cluster_name" {
  type = string
}

# variable "ec2_instances" {
#   description = "Map of EC2 instance configurations"
#   type = map(object({
#     instance_type  = string
#     subnet_id      = any
#     security_group = list(string)
#     public_ip      = bool
#     key_name       = string
#     #user_data     = string
#     volume_size    = number
#     volume_type    = string
#     volume_delete  = bool
#   }))
# }

variable "aws_account_id" {
  type = string
}

variable "company_ip_ranges" {
  type = list(string)
  default = ["210.90.186.162/32", "121.133.247.250/32"]
}

variable "makeshift_measure" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "cluster_workernode_release" {
  type = string
}