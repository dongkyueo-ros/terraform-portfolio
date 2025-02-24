resource "aws_s3_bucket_policy" "allow_cloudfront" {
  for_each = var.sites

  bucket = aws_s3_bucket.static_website[each.key].id
  policy = data.aws_iam_policy_document.cloudfront[each.key].json

}

data "aws_iam_policy_document" "cloudfront" {
  for_each = var.sites

  statement {
    sid     = "AllowCloudFrontServicePrincipalReadOnly"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.static_website[each.key].arn,
      "${aws_s3_bucket.static_website[each.key].arn}/*",
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        var.aws_cloudfront_distribution[each.key].arn
      ]
    }
  }
}