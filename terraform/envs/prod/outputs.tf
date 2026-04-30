output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.app.s3_bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.app.s3_bucket_arn
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  value       = module.app.cloudfront_domain
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID — required for cache invalidation in CI"
  value       = module.app.cloudfront_distribution_id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate in use"
  value       = module.app.acm_certificate_arn
}
