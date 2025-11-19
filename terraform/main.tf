terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # We'll add remote backend (S3) later once the basics are working.
}

provider "aws" {
  region = var.aws_region
}

# For ACM cert (CloudFront requires us-east-1 certs)
provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}