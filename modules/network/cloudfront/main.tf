resource "aws_cloudfront_origin_access_control" "current" {
  for_each = var.sites

  name                              = "OAC ${each.value.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  for_each = var.sites

  depends_on = [var.website_bucket_release, var.logs_bucket_release] #var.virginia_acm_certificate_validation_arn]

  origin {
    domain_name              = var.website_bucket_release[each.key].bucket_regional_domain_name
    origin_id                = "${each.value.bucket_name}-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.current[each.key].id
  }

  # comment         = "${var.bucket_name} distribution"
  comment         = "${each.value.bucket_name} distribution"
  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2and3"
  price_class     = "PriceClass_100" // Because Australia
  // wait_for_deployment = true

  aliases         = each.value.aliases  #each.value.subdomain_name != "" ? ["${each.value.subdomain_name}.${each.value.domain_name}"] : ["${each.value.domain_name}"]
  default_root_object = "index.html"

  default_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = "${each.value.bucket_name}-origin"

    //TODO : function_association

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate  = true
    acm_certificate_arn             = var.ssl_certificate_virginia[each.key].arn
    ssl_support_method              = "sni-only"
    minimum_protocol_version        = "TLSv1.2_2021"
  }

  // standart logging -> s3
  logging_config {
    include_cookies = true
    bucket = "${var.logs_bucket_name}.s3.amazonaws.com"
    prefix = "frontend/${each.value.bucket_name}"
  }

  // 403 Forbidden Error
  custom_error_response {
    error_code       = 403
    response_code    = 200
    response_page_path = "/index.html"
    error_caching_min_ttl = 10
  }
}

resource "aws_cloudfront_function" "whitelisted_ip" {
  for_each = { for k, v in var.sites : k => v if v.use_function }

  name    = "whitelisted-ip-${each.key}-${var.environment}"
  runtime = "cloudfront-js-2.0"
  code    = file("${path.module}/cloudfront-functions/whitelisted-ip.js")
  publish = true
  comment = "${each.value.bucket_name}"
}