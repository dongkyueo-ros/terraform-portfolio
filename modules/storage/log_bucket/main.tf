// S3 bucket logs
resource "aws_s3_bucket" "logs_bucket" {
  bucket = var.logs_bucket_name

  tags = {
    name = var.logs_bucket_name
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_acl" "logs_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.logs_bucket]
  bucket = aws_s3_bucket.logs_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "logs_bucket" {
  bucket = aws_s3_bucket.logs_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "logs_bucket" {
  bucket = aws_s3_bucket.logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// S3 Bucket Intelligent Tiering Setting (Logs)
resource "aws_s3_bucket_intelligent_tiering_configuration" "intelligent_tiering_logs" {
  bucket = aws_s3_bucket.logs_bucket.id
  name   = "intelligent-tiering"

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
}