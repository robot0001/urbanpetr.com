variable "aws_region" {
  description = "AWS region to deploy resources to"
  type        = string
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS profile to use for credentials"
  type        = string
  default     = "terraform"
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
  default     = "static-site"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to create (must be globally unique)"
  type        = string
}

variable "domain_name" {
  description = "Root domain name, e.g. example.com"
  type        = string
}

variable "enable_www" {
  description = "Whether to also serve www.domain"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name: prod or stage"
  type        = string
  default     = "prod"
}

variable "stage_subdomain" {
  description = "Subdomain for stage env (e.g. stage17)"
  type        = string
  default     = ""
}

variable "stage_pr_number" {
  description = "PR number for stage env"
  type        = number
  default     = 0
}
