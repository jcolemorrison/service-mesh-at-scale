resource "tfe_variable_set" "google_cloud" {
  name         = "Google Cloud"
  description  = "Service account credentials for Google Cloud"
  organization = var.tfc_organization
}

resource "tfe_variable" "google_project" {
  key             = "google_project_id"
  value           = var.google_project_id
  category        = "terraform"
  description     = "Google Project ID"
  variable_set_id = tfe_variable_set.google_cloud.id
}

resource "tfe_variable" "google_service_account" {
  key             = "GOOGLE_CREDENTIALS"
  value           = base64decode(var.google_service_account_json)
  category        = "env"
  hcl             = true
  description     = "Google Cloud service account credentials"
  variable_set_id = tfe_variable_set.google_cloud.id
  sensitive       = true
}