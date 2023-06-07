
variable "resource_group_name" {
  default = "coles-magical-azure-cluster"
}

variable "cluster_id" {
  default = "azure"
}

variable "region" {
  default = "westus2"
}

variable "hvn_cidr_block" {
  type        = string
  description = "The cidr block of the hvn"
  default     = "172.25.16.0/20"
}

variable "vnet_cidrs" {
  type        = list(string)
  description = "The ciders of the vnet. This should make sense with vnet_subnets"
  default     = ["10.0.0.0/16"]
}

variable "vnet_subnets" {
  type        = map(string)
  description = "The subnets associated with the vnet"
  default = {
    "subnet1" = "10.0.1.0/24",
    "subnet2" = "10.0.2.0/24",
    "subnet3" = "10.0.3.0/24",
  }
}

variable "peer_datacenter" {
  default = "aws"
  description = "The datacenter for exported services"
}

variable "peer_partition" {
  default = "default"
  description = "The partition for exported services"
}