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
  description = "Project name used for tagging"
  type        = string
  default     = "urbanpetr.com"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to create (must be globally unique)"
  type        = string
  default     = "urbanpetr-website"
}

variable "tf_state_bucket_name" {
  type        = string
  description = "Name of the S3 bucket used for Terraform remote state"
  default     = "urbanpetr-tf-state"
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