# # S3 KMS Key
# resource "aws_kms_key" "s3_key" {
#   description             = "KMS key for S3 bucket encryption"
#   enable_key_rotation = true
# }

# # KMS 키에 대한 별칭 생성
# resource "aws_kms_alias" "s3_key_alias" {
#   name          = "alias/s3-key"
#   target_key_id = aws_kms_key.s3_key.id
# }