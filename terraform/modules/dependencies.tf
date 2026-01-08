data "terraform_remote_state" "foundation" {
  backend = "s3"

  config = {
    bucket = "urbanpetr-tf-state"
    # MUST MATCH the key defined in Foundation's backend.tf
    key    = "foundation/prod/terraform.tfstate"
    region = "eu-central-1"
  }
}