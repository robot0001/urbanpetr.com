locals {
  primary_zone_id = data.terraform_remote_state.foundation.outputs.prod_zone_id

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}