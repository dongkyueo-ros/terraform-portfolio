# S3 src website bucket
resource "aws_s3_bucket" "static_website" {
  for_each = var.sites

  # bucket = var.bucket_name
  bucket = each.value.bucket_name
}

resource "aws_s3_bucket_website_configuration" "website_bucket" {
  for_each = var.sites

  # bucket = aws_s3_bucket.static_website.id
  bucket = aws_s3_bucket.static_website[each.key].id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# S3 bucket ACL access
resource "aws_s3_bucket_ownership_controls" "website_bucket" {
  for_each = var.sites

  # bucket = aws_s3_bucket.static_website.id
  bucket = aws_s3_bucket.static_website[each.key].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket" {
  for_each = var.sites

  # bucket = aws_s3_bucket.static_website.id
  bucket = aws_s3_bucket.static_website[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "website_bucket" {
  for_each = var.sites

  depends_on = [
    aws_s3_bucket_ownership_controls.website_bucket,
    aws_s3_bucket_public_access_block.website_bucket,
  ]

  # bucket = aws_s3_bucket.static_website.id
  bucket = aws_s3_bucket.static_website[each.key].id

  acl    = "private"
}