variable "name" {
  type        = string
  description = "Name for resources"
}

variable "google_project_id" {
  type        = string
  description = "Google Project ID"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region for resources"
  default     = "us-central1"
}

variable "kubernetes_node_size" {
  type        = string
  description = "Node size for Kubernetes cluster"
  default     = "e2-medium"
}