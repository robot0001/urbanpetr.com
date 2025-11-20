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

# Build a map of unique validation records keyed by record name
locals {
  cert_validation_records = {
    for dvo in aws_acm_certificate.site.domain_validation_options :
    dvo.resource_record_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
}

# One Route53 record per unique validation CNAME
resource "aws_route53_record" "cert_validation" {
  for_each = local.cert_validation_records

  zone_id = aws_route53_zone.primary.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

# Final certificate validation resource
resource "aws_acm_certificate_validation" "site" {
  provider        = aws.use1
  certificate_arn = aws_acm_certificate.site.arn
  validation_record_fqdns = [
    for r in aws_route53_record.cert_validation : r.fqdn
  ]
}
