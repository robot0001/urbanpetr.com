variable "aws_region" {
  description = "AWS region to deploy resources to"
  type        = string
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "terraform"
}

variable "project_name" {
  description = "Project name used for tagging (use underscores)"
  type        = string
  default     = "urbanpetr_com"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to create (must be globally unique)"
  type        = string
  default     = "urbanpetr-website"
}

variable "domain_name" {
  description = "Root domain name, e.g. example.com"
  type        = string
  default     = "urbanpetr.com"
}

variable "enable_www" {
  description = "Whether to also serve www.domain"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Deployment environment: prod or stage"
  type        = string
  default     = "prod"
}

variable "stage_subdomain" {
  description = "Subdomain for stage env (e.g. stage10)"
  type        = string
  default     = ""
}

variable "stage_pr_number" {
  description = "The Pull Request number"
  # ZMĚNA ZDE: number -> string
  type    = string
  default = ""
}
