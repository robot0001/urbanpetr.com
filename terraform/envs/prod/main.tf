terraform {
  required_version = ">= 1.5.0"
  
  # Backend config je v backend.tf
}

# 1. Main Provider (Frankfurt)
provider "aws" {
  region  = "eu-central-1"
}

# 2. Special Provider for US East 1 - for certificates
provider "aws" {
  alias   = "use1"
  region  = "us-east-1"
  profile = "terraform"
}

# 3. App modules location
module "app" {
  source = "../../modules"

  providers = {
    aws      = aws      # Main provider
    aws.use1 = aws.use1 # Aliased for certificates
  }

  # Pass vars from prod.tfvars
  project_name   = var.project_name
  aws_region     = var.aws_region
  domain_name    = var.domain_name
  s3_bucket_name = var.s3_bucket_name
  enable_www     = var.enable_www
}