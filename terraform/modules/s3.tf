module "site" {
  source = "github.com/robot0001/urbanpetr-foundation//modules/s3_bucket?ref=feat/unify-tagging"

  bucket_name   = var.s3_bucket_name
  force_destroy = var.environment == "stage" ? true : false

  custom_tags = local.common_tags
}