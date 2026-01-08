variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name (globally unique)"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "enable_www" {
  description = "Enable www redirection"
  type        = bool
}

variable "environment" {
  description = "Target environment (prod or stage)"
  type        = string
  default     = "prod"
}

variable "stage_pr_number" {
  description = "The Pull Request number (only for stage)"
  type        = string
  default     = ""
}

variable "stage_subdomain" {
  description = "The subdomain for the stage env (e.g. stage123)"
  type        = string
  default     = ""
}