# Root A record (e.g., urbanpetr.com) -> Points to Main CloudFront
resource "aws_route53_record" "root_a" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = local.primary_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    # Assuming 'aws_cloudfront_distribution.site' is defined in your cloudfront.tf
    name                   = module.cloudfront.domain_name
    zone_id                = module.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

# WWW A record (e.g., www.urbanpetr.com) -> Points to Main CloudFront
resource "aws_route53_record" "www_a" {
  count = var.environment == "prod" && var.enable_www ? 1 : 0

  zone_id = local.primary_zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.cloudfront.domain_name
    zone_id                = module.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

# Stage A record (e.g., pr-123.urbanpetr.com) -> Points to Stage CloudFront
resource "aws_route53_record" "stage" {
  count = var.environment == "stage" && var.stage_subdomain != "" ? 1 : 0

  zone_id = local.primary_zone_id
  name    = "${var.stage_subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    # Ensure 'aws_cloudfront_distribution.stage' exists in your configuration
    name                   = module.cloudfront.domain_name
    zone_id                = module.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}