variable "google_project_id" {
  type        = string
  description = "Google Project ID for cluster infrastructure"
}

variable "tfc_organization" {
  type        = string
  description = "Terraform Cloud organization for cluster infrastructure"
}

variable "tfc_workspace" {
  type        = string
  description = "Terraform Cloud workspace for cluster infrastructure"
}

variable "peer_datacenter" {
  type        = string
  description = "Datacenter to peer to access"
  default     = "aws"
}

variable "peer_partition" {
  type        = string
  description = "Partition in peered cluster to access"
  default     = "client"
}