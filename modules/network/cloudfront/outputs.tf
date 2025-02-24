output "aws_cloudfront_distribution" {
  value = {
    for key, distribution in aws_cloudfront_distribution.s3_distribution :
      key => distribution
  }
}