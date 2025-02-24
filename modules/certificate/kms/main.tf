# locals {
#   rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.credentials_version.secret_string)
# }

# // Secrets Data 참조
# data "aws_secretsmanager_secret" "rds_credentials" {
#   name = aws_secretsmanager_secret.rds_credentials.name
# }

# // Secrets Version Data 참조
# data "aws_secretsmanager_secret_version" "credentials_version" {
#   secret_id = data.aws_secretsmanager_secret.rds_credentials.id
# }

# // KMS Key 생성
# resource "aws_kms_key" "rds_key" {
#   description = "KMS key for RDS password encryption ${var.aws_primary_region}."
#   enable_key_rotation = true
# }

# // KMS Alias Key
# resource "aws_kms_alias" "rds_key_alias" {
#   name = "alias/rds-key"
#   target_key_id = aws_kms_key.rds_key.id
# }

# // Secrets Manger RDS Credentials 저장
# resource "aws_secretsmanager_secret" "rds_credentials" {
#   name       = "rds-cred"
#   kms_key_id = aws_kms_key.rds_key.id

#   tags = {
#     Name = "rds-cred"
#   }
# }

# // Secrets Manager Version 생성 
# resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
#   secret_id     = aws_secretsmanager_secret.rds_credentials.id
#   secret_string = jsonencode({
#     username = var.rds_username
#     password = var.rds_password
#   })
# }