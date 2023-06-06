# Base requirements for "hooking" Terraform up to AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.59.0"
    }
  }
}

provider "aws" {
  region = var.aws_default_region
  default_tags {
    tags = var.aws_default_tags
  }
}

provider "hcp" {}