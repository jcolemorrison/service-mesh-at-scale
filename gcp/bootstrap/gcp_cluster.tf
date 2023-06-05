resource "tfe_workspace" "gcp_cluster" {
  name                      = "${var.name}-gcp-cluster"
  organization              = var.tfc_organization
  project_id                = data.tfe_project.project.id
  description               = "Workspace for Kubernetes cluster on Google Cloud"
  working_directory         = "gcp/cluster"
  queue_all_runs            = false
  remote_state_consumer_ids = [tfe_workspace.gcp_services.id]
  vcs_repo {
    github_app_installation_id = var.tfc_github_installation_id
    identifier                 = var.github_repository
  }
}

resource "tfe_workspace_variable_set" "google_cloud_cluster" {
  workspace_id    = tfe_workspace.gcp_cluster.id
  variable_set_id = tfe_variable_set.google_cloud.id
}

resource "tfe_variable" "name" {
  key          = "name"
  value        = var.name
  category     = "terraform"
  workspace_id = tfe_workspace.gcp_cluster.id
  description  = "Name of resources"
}