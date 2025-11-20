locals {
  root_record_name = var.domain_name
  www_record_name  = "www.${var.domain_name}"
}

# Root A record for the main site (prod only)
resource "aws_route53_record" "root_a" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = local.primary_zone_id
  name    = local.root_record_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site[0].domain_name
    zone_id                = aws_cloudfront_distribution.site[0].hosted_zone_id
    evaluate_target_health = false
  }
}

# Optional www.<domain> → same CloudFront (prod only, when enabled)
resource "aws_route53_record" "www_a" {
  count = var.environment == "prod" && var.enable_www ? 1 : 0

  zone_id = local.primary_zone_id
  name    = local.www_record_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site[0].domain_name
    zone_id                = aws_cloudfront_distribution.site[0].hosted_zone_id
    evaluate_target_health = false
  }
}
