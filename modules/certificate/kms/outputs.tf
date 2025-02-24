# output "kms_key_rds_arn" {
#   description = "Key for RDS"
#   value       = aws_kms_key.rds_key.arn
# }

# output "kms_key_s3_arn" {
#   description = "Key for S3"
#   value       = aws_kms_key.s3_key.arn
# }

# output "kms_key_rds" {
#   value = aws_kms_key.rds_key
# }

# output "kms_key_rds_id" {
#   description = "The ID of the KMS key"
#   value       = aws_kms_key.rds_key.id
# }

# output "rds_username" {
#   value     = local.rds_credentials.username
#   sensitive = true
# }

# output "rds_password" {
#   value     = local.rds_credentials.password
#   sensitive = true
# }
