output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID — required for cache invalidation in CI"
  value       = module.app.cloudfront_distribution_id
}
