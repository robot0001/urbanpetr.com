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