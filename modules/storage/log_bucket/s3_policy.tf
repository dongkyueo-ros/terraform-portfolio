// cloudfront logs policy
resource "aws_s3_bucket_policy" "logs_bucket_policy" {
  bucket = aws_s3_bucket.logs_bucket.id
  policy = data.aws_iam_policy_document.logs_bucket.json
  depends_on = [aws_s3_bucket.logs_bucket]
}

data "aws_iam_policy_document" "logs_bucket" {
  statement {
    sid     = "AllowCloudFrontServicePrincipalReadOnly"
    effect  = "Allow"
    actions = [
        "s3:PutObject",
        "s3:GetBucketAcl",
        "s3:PutBucketAcl"
    ]
    resources = [
      aws_s3_bucket.logs_bucket.arn,
      "${aws_s3_bucket.logs_bucket.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    dynamic "condition" {
      for_each = var.aws_cloudfront_distribution
      content {
        test     = "StringEquals"
        variable = "AWS:SourceArn"
        values   = [condition.value.arn]
      }
    }
  }
}