terraform {
  backend "s3" {
    bucket         = "urbanpetr-tf-state"
    key            = "urbanpetr_admin/prod/terraform.tfstate"
    dynamodb_table = "terraform-locks"
    region         = "eu-central-1"
    encrypt        = true
  }
}
