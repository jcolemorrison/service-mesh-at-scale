data "tfe_project" "project" {
  name         = var.tfc_project
  organization = var.tfc_organization
}

resource "tfe_workspace" "gcp_services" {
  name                      = "${var.name}-gcp-services"
  organization              = var.tfc_organization
  project_id                = data.tfe_project.project.id
  description               = "Workspace for services that run on Google Cloud"
  working_directory         = "gcp/services"
  queue_all_runs            = false
  remote_state_consumer_ids = []
  vcs_repo {
    github_app_installation_id = var.tfc_github_installation_id
    identifier                 = var.github_repository
    branch                     = var.github_branch
  }
}

resource "tfe_workspace_variable_set" "google_cloud_services" {
  workspace_id    = tfe_workspace.gcp_services.id
  variable_set_id = tfe_variable_set.google_cloud.id
}

resource "tfe_variable" "tfc_organization_services" {
  key          = "tfc_organization"
  value        = var.tfc_organization
  category     = "terraform"
  workspace_id = tfe_workspace.gcp_services.id
  description  = "TFC Organization for Kubernetes cluster details"
}

resource "tfe_variable" "tfc_workspace_services" {
  key          = "tfc_workspace"
  value        = tfe_workspace.gcp_cluster.name
  category     = "terraform"
  workspace_id = tfe_workspace.gcp_services.id
  description  = "TFC Workspace for Kubernetes cluster details"
}