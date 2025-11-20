# Root A record for main site (prod only)
resource "aws_route53_record" "root_a" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = local.primary_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site[0].domain_name
    zone_id                = aws_cloudfront_distribution.site[0].hosted_zone_id
    evaluate_target_health = false
  }
}

# Optional www.<domain> -> main CloudFront (prod only)
resource "aws_route53_record" "www_a" {
  count = var.environment == "prod" && var.enable_www ? 1 : 0

  zone_id = local.primary_zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site[0].domain_name
    zone_id                = aws_cloudfront_distribution.site[0].hosted_zone_id
    evaluate_target_health = false
  }
}

# Stage A record: stage{PR}.domain -> stage CloudFront (stage only)
resource "aws_route53_record" "stage" {
  count = var.environment == "stage" && var.stage_subdomain != "" ? 1 : 0

  zone_id = local.primary_zone_id
  name    = "${var.stage_subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.stage[0].domain_name
    zone_id                = aws_cloudfront_distribution.stage[0].hosted_zone_id
    evaluate_target_health = false
  }
}
