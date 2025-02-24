output "acm_certificate_arn_region" {
  value = data.aws_acm_certificate.ssl_certificate_region.arn
}

output "ssl_certificate_virginia" {
  value = {
    for acm, certificate in data.aws_acm_certificate.ssl_certificate_virginia :
    acm => certificate
  }
}

# output "acm_certificate_ssl_certificate_virginia_arn" {
#   value = aws_acm_certificate.ssl_certificate_virginia.arn
# }

# output "acm_certificate_ssl_certificate_region_arn" {
#   value = aws_acm_certificate.ssl_certificate_seoul.arn
# }

# output "seoul_acm_certificate_validation_arn" {
#   value = aws_acm_certificate_validation.seoul_acm_dns.certificate_arn
# }

# output "virginia_acm_certificate_validation_arn" {
#   value = aws_acm_certificate_validation.virginia_acm_dns.certificate_arn
# }