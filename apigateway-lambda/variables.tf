# variables.tf
variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-2" # Change to your preferred region
}

variable "sso_shared_config_files" {
  type        = list(string)
  description = "SSO configuration file"
}

variable "sso_profile" {
  type        = string
  description = "SSO profile name"
}

variable "resource_prefix" {
  description = "A prefix for resource names to ensure uniqueness and organization."
  type        = string
  default     = "my-app"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "api_stage_name" {
  description = "The name of the API Gateway stage (e.g., v1, dev, prod)."
  type        = string
  default     = "v1"
}