output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

// Terraform Cloud IP Range Output
output "terraform_cloud_api_ip_ranges" {
  description = "Terraform Cloud API IP Ranges as JSON"
  value       = local.terraform_cloud_ip_ranges.api
}

output "terraform_cloud_notifications_ip_ranges" {
  description = "Terraform Cloud Notifications IP Ranges as JSON"
  value       = local.terraform_cloud_ip_ranges.notifications
}

output "terraform_cloud_sentinel_ip_ranges" {
  description = "Terraform Cloud Sentinel Runner IP Ranges as JSON"
  value       = local.terraform_cloud_ip_ranges.sentinel
}

output "terraform_cloud_ip_ranges" {
  description = "Terraform Cloud VCS Integration IP Ranges as JSON"
  value       = local.terraform_cloud_ip_ranges.vcs
}

output "bastion_public_eip" {
  value = aws_eip.bastion.public_ip
}

output "bastion_id" {
  value = aws_instance.bastion.id
}