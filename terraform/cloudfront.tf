resource "aws_cloudfront_origin_access_identity" "site" {
  comment = "Access identity for static site"
}

data "aws_iam_policy_document" "site_bucket_policy" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.site.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.site.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.site_bucket_policy.json
}

locals {
  # Prod aliases: root + optional www
  prod_cf_aliases = var.enable_www ? [var.domain_name, "www.${var.domain_name}"] : [var.domain_name]

  # Stage alias: stage{PR}.domain (only when stage_subdomain is set)
  stage_cf_aliases = var.stage_subdomain != "" ? ["${var.stage_subdomain}.${var.domain_name}"] : []
}

# =========================
# Prod CloudFront distribution
# =========================
resource "aws_cloudfront_distribution" "site" {
  count              = var.environment == "prod" ? 1 : 0
  enabled            = true
  is_ipv6_enabled    = true
  default_root_object = "index.html"

  aliases = local.prod_cf_aliases

  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id   = "s3-site-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.site.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-site-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = local.site_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Project = var.project_name
  }
}

# =========================
# Stage CloudFront distribution (per PR)
# =========================
resource "aws_cloudfront_distribution" "stage" {
  count               = var.environment == "stage" ? 1 : 0
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = local.stage_cf_aliases

  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id   = "s3-stage-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.site.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-stage-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = local.site_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Project = var.project_name
  }
}
