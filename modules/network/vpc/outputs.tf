output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "pb_subnet_ids" {
  description = "ID list of public id subnet"
  value       = [for subnet in aws_subnet.public_subnets : subnet.id ]
}

output "pv_subnet_eks_ids" {
  description = "ID list of private subnet id in eks azs a, b, c"
  value       = [for subnet in aws_subnet.private_subnets_eks : subnet.id ]
}

output "pv_subnet_master_ids" {
  description = "ID list of private subnet id in db azs a, b, c"
  value       = [for subnet in aws_subnet.private_subnets_master : subnet.id ]
}


output "pv_subnet_db_ids" {
  description = "ID list of private subnet id in db azs a, b, c"
  value       = [for subnet in aws_subnet.private_subnets_db : subnet.id ]
}

output "pb_subnets" {
  description = "ID list of public subnet"
  value       = [for subnet in aws_subnet.public_subnets : subnet ]
}

output "pv_subnets_eks" {
  description = "ID list of private subnet in eks azs a, b, c"
  value       = [for subnet in aws_subnet.private_subnets_eks : subnet ]
}

output "pv_subnets_master" {
  description = "ID list of private subnet in eks azs a, b, c"
  value       = [for subnet in aws_subnet.private_subnets_master : subnet ]
}

output "pv_subnets_db" {
  description = "ID list of private subnet in db azs a, b, c"
  value       = [for subnet in aws_subnet.private_subnets_db : subnet ]
}