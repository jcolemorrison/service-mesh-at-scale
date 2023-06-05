variable "name" {
  type        = string
  description = "Name of resources"
}

variable "tfc_organization" {
  type        = string
  description = "TFC organization to create workspace for GCP cluster"
}

variable "tfc_project" {
  type        = string
  description = "TFC project to create workspace for GCP cluster"
}

variable "tfc_github_installation_id" {
  type        = string
  description = "TFC GitHub App installation ID"
}

variable "github_repository" {
  type        = string
  description = "Github repository to reference in workspaces"
}

variable "github_branch" {
  type        = string
  description = "Github repository branch to reference in workspaces"
  default     = "main"
}

variable "google_project_id" {
  type        = string
  description = "Google project ID to create resources"
  sensitive   = true
}

variable "google_service_account_json" {
  type        = string
  description = "Base64-encoded Google service account JSON file contents"
  sensitive   = true
}