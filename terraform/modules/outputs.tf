output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = module.site.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = module.site.bucket_arn
}

output "cloudfront_domain" {
  description = "Domain name of the CloudFront distribution"
  value       = module.cloudfront.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID — required for cache invalidation in CI"
  value       = module.cloudfront.distribution_id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate in use"
  value       = module.acm_certificate.certificate_arn
}