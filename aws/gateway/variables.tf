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