module "site" {
  source = "github.com/robot0001/urbanpetr-foundation//modules/s3_bucket?ref=v1.1.1"

  bucket_name   = var.s3_bucket_name
  force_destroy = var.environment == "stage" ? true : false

  custom_tags = local.common_tags
}