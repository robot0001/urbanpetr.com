# Hosted zone is created only in the prod environment.
resource "aws_route53_zone" "primary" {
  count = var.environment == "prod" ? 1 : 0

  name = var.domain_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# In the stage environment we only look up the existing hosted zone.
data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}

# Unified reference to the primary zone ID for use across other TF files.
locals {
  primary_zone_id = var.environment == "prod" ? aws_route53_zone.primary[0].zone_id : data.aws_route53_zone.primary.zone_id
}
