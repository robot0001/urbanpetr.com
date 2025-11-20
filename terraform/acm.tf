locals {
  # Domains we want covered by the certificate:
  # - root domain
  # - optional www
  # - wildcard for all future subdomains (e.g. stage10.domain.com)
  cert_domains = var.enable_www ? [var.domain_name, "www.${var.domain_name}", "*.${var.domain_name}"] : [var.domain_name, "*.${var.domain_name}"]
}

# Single ACM certificate in us-east-1 for CloudFront
resource "aws_acm_certificate" "site" {
  provider          = aws.use1
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

locals {
  cert_validation_options_by_domain = {
    for dvo in aws_acm_certificate.site.domain_validation_options :
    dvo.domain_name => dvo
  }
}

# DNS validation records for all domains covered by the cert
resource "aws_route53_record" "cert_validation" {
  for_each = { for d in local.cert_domains : d => d }

  zone_id = aws_route53_zone.primary.zone_id
  name    = local.cert_validation_options_by_domain[each.key].resource_record_name
  type    = local.cert_validation_options_by_domain[each.key].resource_record_type
  ttl     = 60
  records = [
    local.cert_validation_options_by_domain[each.key].resource_record_value
  ]
}

# Final certificate validation resource
resource "aws_acm_certificate_validation" "site" {
  provider        = aws.use1
  certificate_arn = aws_acm_certificate.site.arn
  validation_record_fqdns = [
    for r in aws_route53_record.cert_validation : r.fqdn
  ]
}
