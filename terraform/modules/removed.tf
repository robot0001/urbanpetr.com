# OAI was replaced by OAC. Removed from state here so Terraform stops
# trying to delete it (AWS returns 409 until distribution fully deploys).
# After applying, delete the OAI manually from the AWS console:
# CloudFront → Origin access → Origin access identities → E3BPFET6LDC73T → Delete
removed {
  from = module.cloudfront.aws_cloudfront_origin_access_identity.this

  lifecycle {
    destroy = false
  }
}
