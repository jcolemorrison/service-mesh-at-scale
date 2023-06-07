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
    consul = {
      source = "hashicorp/consul"
      version = "~> 2.17.0"
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

provider "consul" {}

# Note: filter out wavelength zones if they're enabled in the account being deployed to.
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "group-name"
    values = [var.aws_default_region]
  }
}
