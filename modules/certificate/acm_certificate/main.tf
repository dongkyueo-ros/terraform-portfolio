// 생성되어 있는 ACM 인증서 사용
data "aws_acm_certificate" "ssl_certificate_virginia" {
  for_each = var.sites

  domain   = each.value.domain_name
  types       = ["AMAZON_ISSUED"]
  statuses    = ["ISSUED"]
  most_recent = true
  provider    = aws.virginia
}

data "aws_acm_certificate" "ssl_certificate_region" {
  domain      = var.acm_certificate_domain_name
  types       = ["AMAZON_ISSUED"]
  statuses    = ["ISSUED"]
  most_recent = true
  provider    = aws.seoul
}


######################## ACM 인증서 생성 후 적용하는 내용 #########################
# // ACM Certificate 생성 (Virginia)
# resource "aws_acm_certificate" "ssl_certificate_virginia" {
#   provider                   = aws.virginia
#   domain_name                = var.acm_certificate_domain_name
#   subject_alternative_names  = ["*.${var.acm_certificate_domain_name}"]
#   validation_method          = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# // ACM Certificate 생성 (seoul)
# resource "aws_acm_certificate" "ssl_certificate_seoul" {
#   provider                   = aws.seoul
#   domain_name                = var.acm_certificate_domain_name
#   subject_alternative_names  = ["*.${var.acm_certificate_domain_name}"]
#   validation_method          = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# data "aws_route53_zone" "dns_zone" {
#   name         = var.acm_certificate_domain_name
#   private_zone = false
# }

# resource "aws_route53_record" "virginia_acm_dns" {
#   provider = aws.virginia
#   for_each = {
#     for dvo in aws_acm_certificate.ssl_certificate_virginia.domain_validation_options : dvo.domain_name => {
#       name    = dvo.resource_record_name
#       record  = dvo.resource_record_value
#       type    = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.dns_zone.zone_id
# }

# resource "aws_route53_record" "seoul_acm_dns" {
#   provider = aws.seoul
#   for_each = {
#     for dvo in aws_acm_certificate.ssl_certificate_seoul.domain_validation_options : dvo.domain_name => {
#       name    = dvo.resource_record_name
#       record  = dvo.resource_record_value
#       type    = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.dns_zone.zone_id
# }

# // 인증서 발급을 위한 인증에 대한 리소스
# resource "aws_acm_certificate_validation" "virginia_acm_dns" {
#   provider                = aws.virginia
#   certificate_arn         = aws_acm_certificate.ssl_certificate_virginia.arn
#   validation_record_fqdns = [for record in aws_route53_record.virginia_acm_dns : record.fqdn]
# }

# resource "aws_acm_certificate_validation" "seoul_acm_dns" {
#   provider                = aws.seoul
#   certificate_arn         = aws_acm_certificate.ssl_certificate_seoul.arn
#   validation_record_fqdns = [for record in aws_route53_record.seoul_acm_dns : record.fqdn]
# }

############################### SSL 인증 리소스 이미 존재 #################################
# # Uncomment the validation_record_fqdns line if you do DNS validation instead of Email.
# resource "aws_acm_certificate_validation" "cert_validation" {
#   certificate_arn         = data.aws_acm_certificate.ssl_certificate.arn
#   validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
# }

# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in data.aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }
#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.existing.zone_id
# }