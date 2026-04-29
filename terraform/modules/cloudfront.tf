# 1. Calculate Aliases (Logic moved from locals)
locals {
  # Prod: [example.com, www.example.com] or just [example.com]
  prod_aliases = var.environment == "prod" ? (var.enable_www ? [var.domain_name, "www.${var.domain_name}"] : [var.domain_name]) : []

  # Stage: [pr-1.example.com] or []
  stage_aliases = var.environment == "stage" && var.stage_subdomain != "" ? ["${var.stage_subdomain}.${var.domain_name}"] : []

  # Final list to pass to module
  final_aliases = concat(local.prod_aliases, local.stage_aliases)
}

# 2. Call the new Module
module "cloudfront" {
  source = "github.com/robot0001/urbanpetr-foundation//modules/cloudfront_website?ref=v1.1.1"

  project_name = var.project_name
  environment  = var.environment

  # Pass the S3 data (Assumes module.site exists from previous steps)
  # IMPORTANT: Check if your S3 module outputs 'bucket_regional_domain_name'.
  # If not, use 'bucket_domain_name' but regional is better.
  bucket_domain_name = module.site.bucket_regional_domain_name

  # Pass the calculated aliases
  aliases = local.final_aliases

  # Pass the Certificate (We need to define where this comes from!)
  acm_certificate_arn = local.site_certificate_arn

  custom_tags = local.common_tags
}

# 3. The Glue: Allow CloudFront to read S3
# This stays in the App because it links Module A (S3) with Module B (CloudFront)
data "aws_iam_policy_document" "site_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.site.bucket_arn}/*"] # Updated to use module output

    principals {
      type        = "AWS"
      identifiers = [module.cloudfront.oai_iam_arn] # Use output from CloudFront module
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = module.site.bucket_id # Updated to use module output
  policy = data.aws_iam_policy_document.site_bucket_policy.json
}