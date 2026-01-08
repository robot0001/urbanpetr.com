locals {
  # Logic: Prod gets wildcard + www. Stage reuses the wildcard from Prod.
  # So we only need to define SANs for Prod creation.
  cert_sans = var.enable_www ? ["www.${var.domain_name}", "*.${var.domain_name}"] : ["*.${var.domain_name}"]
}

module "acm_certificate" {
  source = "github.com/robot0001/urbanpetr-foundation//modules/acm_certificate?ref=v1.0.0"

  # MAGICAL LINE: This tells the module to use the us-east-1 provider
  providers = {
    aws = aws.use1
  }

  # Logic: Only create in Prod. In Stage, we will lookup.
  create_cert = var.environment == "prod"
  
  domain_name               = var.domain_name
  subject_alternative_names = local.cert_sans
  
  # We use the zone ID from locals.tf (which comes from Foundation)
  zone_id = local.primary_zone_id

  tags = {
    Project = var.project_name
  }
}

# Define the local variable that cloudfront.tf is expecting
locals {
  site_certificate_arn = module.acm_certificate.certificate_arn
}