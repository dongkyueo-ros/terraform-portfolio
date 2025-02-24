output "attached_policies" {
  value = {
    for k, v in aws_iam_role_policy.s3_deployment_policy_attachment : k => v.name
  }
}