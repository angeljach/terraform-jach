terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region              = var.aws_region
  shared_config_files = var.sso_shared_config_files
  profile             = var.sso_profile
}