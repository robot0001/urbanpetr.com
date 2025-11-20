locals {
  # Domains we want covered by the certificate:
  # - root domain
  # - optional www
  # - wildcard for all future subdomains (e.g. stage10.domain.com)
  cert_domains = var.enable_www ? [var.domain_name, "www.${var.domain_name}", "*.${var.domain_name}"] : [var.domain_name, "*.${var.domain_name}"]
}

# ACM certificate is created/managed only in prod.
resource "aws_acm_certificate" "site" {
  provider          = aws.use1
  count             = var.environment == "prod" ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"

  # SANs:
  # - if enable_www = true: www.domain.com + *.domain.com
  # - else: *.domain.com only
  subject_alternative_names = var.enable_www ? ["www.${var.domain_name}", "*.${var.domain_name}"] : ["*.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Project = var.project_name
  }
}

# Group validation options by record name (CNAME), dedupe them correctly
locals {
  cert_validation_records = var.environment == "prod" ? {
    for name, dvos in {
      for dvo in aws_acm_certificate.site[0].domain_validation_options :
      dvo.resource_record_name => dvo...
    } :
    name => {
      name  = name
      type  = dvos[0].resource_record_type
      value = dvos[0].resource_record_value
    }
  } : {}
}

# One Route53 record per unique validation CNAME (prod only).
resource "aws_route53_record" "cert_validation" {
  for_each = local.cert_validation_records

  zone_id = local.primary_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]

  allow_overwrite = true
}

# Final certificate validation resource (prod only).
resource "aws_acm_certificate_validation" "site" {
  provider        = aws.use1
  count           = var.environment == "prod" ? 1 : 0
  certificate_arn = aws_acm_certificate.site[0].arn
  validation_record_fqdns = [
    for r in aws_route53_record.cert_validation : r.fqdn
  ]
}

# In stage environment we look up the existing wildcard certificate.
data "aws_acm_certificate" "existing" {
  provider = aws.use1

  # Use wildcard domain so we always pick the cert that covers *.domain.com
  domain      = "*.${var.domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}

# Unified certificate ARN for CloudFront/use elsewhere.
locals {
  site_certificate_arn = var.environment == "prod" ? aws_acm_certificate_validation.site[0].certificate_arn : data.aws_acm_certificate.existing.arn
}
