output "s3_bucket_name" {
  description = "Admin S3 bucket name"
  value       = module.bucket.bucket_id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID — required for cache invalidation in CI"
  value       = module.cdn.distribution_id
}

output "cloudfront_domain" {
  description = "CloudFront domain name"
  value       = module.cdn.domain_name
}
