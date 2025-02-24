output "waf_acl_cdn_arn" {
  description = "The IDs of the WAF ACLs"
  value       = { 
    for key, value in aws_wafv2_web_acl.waf_cdn : key => value.arn
  }
}

output "waf_acl_alb_arns" {
  description = "The ARNs of the WAF ACLs"
  value       = { 
    for key, value in aws_wafv2_web_acl.waf_alb : key => value.arn 
  }
}
