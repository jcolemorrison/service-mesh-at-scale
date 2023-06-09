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
    Project = "service-mesh-catalog"
  }
}

# AWS VPC Settings and Options
variable "vpc_cidr" {
  type        = string
  description = "Cidr block for the VPC.  Using a /16 or /20 Subnet Mask is recommended."
  default     = "10.252.0.0/20"
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

# REQUIRED Variables
variable "hcp_consul_cluster_id" {
  type = string
  description = "ID of the HCP Consul Cluster"
}

variable "hvn_id" {
  type = string
  description = "ID of the HCP HVN the HCP cluster is deployed into"
}

variable "transit_gateway_id" {
  type = string
  description = "ID of the transit gateway used to connect all of the AWS service VPCs"
}

variable "consul_root_token_secret_id" {
  type = string
  description = "Root token secret ID needed for bootstrapping consul.  Retrieve this from the created HCP consul cluster in the consul project that is sibling to this one."
}