resource "aws_s3_bucket" "site" {
  bucket = var.s3_bucket_name

  tags = {
    Project = var.project_name
  }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -------------------------------------------------------------------
# Terraform state bucket (backend)
# -------------------------------------------------------------------

resource "aws_s3_bucket" "tf_state" {
  bucket = var.tf_state_bucket_name

  tags = {
    Project = var.project_name
    Purpose = "terraform-state"
  }
}

# Enable versioning on the state bucket (strongly recommended)
resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt state at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lock down public access for the state bucket
resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}