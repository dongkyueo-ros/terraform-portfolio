data "aws_route53_zone" "existing" {
  for_each = var.sites
  name         = each.value.domain_name
  private_zone = false
}

resource "aws_route53_record" "domain" {
  for_each = var.sites

  zone_id = data.aws_route53_zone.existing[each.key].zone_id
  name    = "${each.value.subdomain_name != "" ? "${each.value.subdomain_name}.${each.value.domain_name}" : each.value.domain_name}"
  type    = "A"

  alias {
    name                   = var.aws_cloudfront_distribution[each.key].domain_name
    zone_id                = var.aws_cloudfront_distribution[each.key].hosted_zone_id    
    evaluate_target_health = false
  }
}
