terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

locals {
  domain    = "urbanpetr.com"
  subdomain = "admin.urbanpetr.com"

  common_tags = {
    Project     = "urbanpetr_admin"
    Environment = "prod"
  }
}

# Route53 zone ID from shared foundation state
data "terraform_remote_state" "foundation" {
  backend = "s3"

  config = {
    bucket = "urbanpetr-tf-state"
    key    = "foundation/prod/terraform.tfstate"
    region = "eu-central-1"
  }
}

# Reuse existing *.urbanpetr.com wildcard cert (covers admin.urbanpetr.com)
data "aws_acm_certificate" "wildcard" {
  provider    = aws.use1
  domain      = local.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

# S3 bucket for admin static files
module "bucket" {
  source = "github.com/robot0001/urbanpetr-foundation//modules/s3_bucket?ref=v1.1.1"

  bucket_name   = "urbanpetr-admin"
  force_destroy = false
  custom_tags   = local.common_tags
}

# CloudFront distribution serving admin.urbanpetr.com
module "cdn" {
  source = "github.com/robot0001/urbanpetr-foundation//modules/cloudfront_website?ref=v1.2.0"

  project_name        = "urbanpetr_admin"
  environment         = "prod"
  bucket_domain_name  = module.bucket.bucket_regional_domain_name
  aliases             = [local.subdomain]
  acm_certificate_arn = data.aws_acm_certificate.wildcard.arn
  custom_tags         = local.common_tags
}

# Allow CloudFront OAC to read the admin S3 bucket
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.bucket.bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cdn.distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "admin" {
  bucket = module.bucket.bucket_id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

# DNS: admin.urbanpetr.com → CloudFront
resource "aws_route53_record" "admin" {
  zone_id = data.terraform_remote_state.foundation.outputs.prod_zone_id
  name    = local.subdomain
  type    = "A"

  alias {
    name                   = module.cdn.domain_name
    zone_id                = module.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
