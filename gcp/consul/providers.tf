terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.66.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.21.0"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.17.0"
    }
  }
}

data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = var.tfc_organization
    workspaces = {
      name = var.tfc_workspace
    }
  }
}

provider "google" {
  project = var.google_project_id
}

data "google_client_config" "default" {}

data "google_container_cluster" "gcp" {
  name     = data.terraform_remote_state.cluster.outputs.google_cluster_name
  location = data.terraform_remote_state.cluster.outputs.google_cluster_location
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.gcp.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gcp.master_auth[0].cluster_ca_certificate)
}

data "kubernetes_service" "consul" {
  metadata {
    name      = "consul-ui"
    namespace = "consul"
  }
}

data "kubernetes_secret" "consul" {
  metadata {
    name      = "consul-bootstrap-token"
    namespace = "consul"
  }
}

provider "consul" {
  address        = data.kubernetes_service.consul.status.0.load_balancer.0.ingress.0.ip
  token          = data.kubernetes_secret.consul.data.token
  insecure_https = true
  scheme         = "https"
}