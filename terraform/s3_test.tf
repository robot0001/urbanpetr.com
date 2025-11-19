resource "aws_s3_bucket" "tmp_test" {
  bucket = "urbanpetr-tmp-test-01"  # dej něco globálně unikátního

  tags = {
    Project = var.project_name
    Purpose = "ci-test"
  }
}