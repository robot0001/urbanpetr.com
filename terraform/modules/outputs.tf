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