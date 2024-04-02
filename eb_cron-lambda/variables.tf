variable "sso_shared_config_files" {
  type        = list(string)
  description = "SSO configuration file"
}

variable "sso_profile" {
  type        = string
  description = "SSO profile name"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}
