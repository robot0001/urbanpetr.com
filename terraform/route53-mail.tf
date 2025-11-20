# CNAME: mail.urbanpetr.com -> ghs.google.com (prod only)
resource "aws_route53_record" "mail_cname" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = local.primary_zone_id
  name    = "mail.${var.domain_name}" # mail.urbanpetr.com
  type    = "CNAME"
  ttl     = 1800

  records = ["ghs.google.com."]
}

# MX records for Google Apps / Workspace (prod only)
resource "aws_route53_record" "mx_google" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = local.primary_zone_id
  name    = var.domain_name # urbanpetr.com
  type    = "MX"
  ttl     = 1800

  records = [
    "10 aspmx.l.google.com.",
    "20 alt1.aspmx.l.google.com.",
    "20 alt2.aspmx.l.google.com.",
    "30 aspmx2.googlemail.com.",
    "30 aspmx3.googlemail.com.",
    "30 aspmx4.googlemail.com.",
    "30 aspmx5.googlemail.com.",
  ]
}