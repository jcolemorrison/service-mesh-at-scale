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
    Project = "service-mesh-client"
  }
}

# AWS VPC Settings and Options
variable "vpc_cidr" {
  type        = string
  description = "Cidr block for the VPC.  Using a /16 or /20 Subnet Mask is recommended."
  default     = "10.253.0.0/20"
}

variable "vpc_instance_tenancy" {
  type        = string
  description = "Tenancy for instances launched into the VPC."
  default     = "default"
}

variable "vpc_public_subnet_count" {
  type        = number
  description = "The number of public subnets to create.  Cannot exceed the number of AZs in your selected region.  2 is more than enough."
  default     = 3
}

variable "vpc_private_subnet_count" {
  type        = number
  description = "The number of private subnets to create.  Cannot exceed the number of AZs in your selected region."
  default     = 3
}
