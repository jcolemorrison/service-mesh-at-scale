# Convenience locals for usage throughout the project
locals {
  project_tag = var.aws_default_tags.Project
  shared_account_principals = flatten([hcp_hvn.hvn_service_mesh_at_scale.provider_account_id, var.shared_account_principals])
}