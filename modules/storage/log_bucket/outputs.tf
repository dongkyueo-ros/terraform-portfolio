output "logs_bucket_name" {
  value = aws_s3_bucket.logs_bucket.bucket
}

output "logs_bucket_release" {
  value = aws_s3_bucket.logs_bucket.bucket_domain_name
}