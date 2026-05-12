terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "stage_number" {
  type    = string
  default = ""
}

provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

locals {
  domain      = "urbanpetr.com"
  subdomain   = var.environment == "stage" ? "admin-stage${var.stage_number}.${local.domain}" : "admin.${local.domain}"
  bucket_name = var.environment == "stage" ? "urbanpetr-admin-stage-${var.stage_number}" : "urbanpetr-admin"

  common_tags = {
    Project     = "urbanpetr_admin"
    Environment = var.environment
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

# Wildcard cert covers both admin.urbanpetr.com and admin-stageN.urbanpetr.com
data "aws_acm_certificate" "wildcard" {
  provider    = aws.use1
  domain      = local.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

module "bucket" {
  source = "github.com/robot0001/urbanpetr-foundation//modules/s3_bucket?ref=v1.1.1"

  bucket_name   = local.bucket_name
  force_destroy = var.environment == "stage"
  custom_tags   = local.common_tags
}

module "cdn" {
  source = "github.com/robot0001/urbanpetr-foundation//modules/cloudfront_website?ref=v1.3.3"

  project_name        = "urbanpetr_admin"
  environment         = var.environment
  bucket_domain_name  = module.bucket.bucket_regional_domain_name
  aliases             = [local.subdomain]
  acm_certificate_arn = data.aws_acm_certificate.wildcard.arn
  spa_routing         = true
  custom_tags         = local.common_tags
}

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
