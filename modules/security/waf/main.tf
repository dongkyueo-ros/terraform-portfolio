provider "aws" {
  region = "us-east-1"
  alias = "virginia"
}

// WAF Web ACL CloudFront
resource "aws_wafv2_web_acl" "waf_cdn" {
  for_each = var.waf_cdn
  provider = aws.virginia

  name  = "waf-${var.environment}-ue1-${var.project}-${each.key}"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = each.value.visibility_config.cloudwatch_metrics_enabled
    metric_name                = each.value.visibility_config.metric_name
    sampled_requests_enabled   = each.value.visibility_config.sampled_requests_enabled
  }

  tags = {
    Name = "waf-${var.environment}-ue1-${var.project}-${each.key}"
  }
}


// WAF Web ACL ALB
resource "aws_wafv2_web_acl" "waf_alb" {
  for_each = var.waf_alb

  name  = "waf-${var.environment}-${var.region}-${var.project}-${each.key}"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = each.value.visibility_config.cloudwatch_metrics_enabled
    metric_name                = each.value.visibility_config.metric_name
    sampled_requests_enabled   = each.value.visibility_config.sampled_requests_enabled
  }

  tags = {
    Name = "waf-${var.environment}-${var.region}-${var.project}-${each.key}"
  }
}