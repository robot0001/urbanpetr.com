locals {
  primary_zone_id = data.terraform_remote_state.foundation.outputs.prod_zone_id
}