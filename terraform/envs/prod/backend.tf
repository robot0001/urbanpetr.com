terraform {
  backend "s3" {
    bucket         = "urbanpetr-tf-state"
    key            = "state/terraform.tfstate"
    dynamodb_table = "terraform-locks"
    region         = "eu-central-1"
    encrypt        = true
  }
}