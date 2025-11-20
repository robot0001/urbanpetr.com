locals {
  # In prod: request certificate for apex + wildcard (*.domain)
  # In stage: we will only look up the existing wildcard certificate.
  cert_domains = [
    var.domain_name,          # example.com
    "*.${var.domain_name}",   # *.example.com
  ]
}

# Certificate is created only in the prod environment.
resource "aws_acm_certificate" "site" {
  provider = aws.use1
  count    = var.environment == "prod" ? 1 : 0

  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

locals {
  # Validation options are only available when the certificate is created (prod).
  cert_validation_options_by_domain = var.environment == "prod" ? {
    for dvo in aws_acm_certificate.site[0].domain_validation_options :
    dvo.domain_name => dvo
  } : {}
}

# DNS validation records — only for prod.
resource "aws_route53_record" "cert_validation" {
  for_each = var.environment == "prod" ? {
    for d in local.cert_domains : d => d
  } : {}

  zone_id = local.primary_zone_id
  name    = local.cert_validation_options_by_domain[each.key].resource_record_name
  type    = local.cert_validation_options_by_domain[each.key].resource_record_type
  ttl     = 60
  records = [
    local.cert_validation_options_by_domain[each.key].resource_record_value
  ]
}

# Certificate validation — only in prod.
resource "aws_acm_certificate_validation" "site" {
  provider = aws.use1
  count    = var.environment == "prod" ? 1 : 0

  certificate_arn = aws_acm_certificate.site[0].arn
  validation_record_fqdns = [
    for r in aws_route53_record.cert_validation : r.fqdn
  ]
}

# In stage environment we look up the already issued wildcard certificate.
data "aws_acm_certificate" "site" {
  provider = aws.use1

  domain      = "*.${var.domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}

# Unified reference for CloudFront or other resources to use the correct cert ARN.
locals {
  site_certificate_arn = var.environment == "prod" ? aws_acm_certificate_validation.site[0].certificate_arn : data.aws_acm_certificate.site.arn
}
