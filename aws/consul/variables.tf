# AWS Provider Default Settings
variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "service-mesh-tgw"
  }
}

variable "hvn_cidr_block" {
  type = string
  default = "172.26.16.0/20"
}

variable "transit_gateway_cidr_block" {
  type = string
  description = "CIDR block for the transit gateway to exist in.  Cannot overlap with any other CIDR."
  default = "10.254.0.0/24"
}

variable "shared_account_principals" {
  type = list(string)
  description = "List of AWS Principals (i.e. accounts) to share the transit gateway with"
  default = []
}

variable "spoke_vpc_cidrs" {
  type = list(string)
  description = "List of VPC cidr blocks connecting to this transit gateway"
  default = []
}

## Required

variable "hcp_project_id" {
  type = string
  description = "ID of the HCP project"
}

variable "hcp_organization_id" {
  type = string
  description = "ID of the HCP organization"
}
