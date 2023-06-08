resource "google_service_account" "default" {
  account_id   = "${var.name}-k8s"
  display_name = "${var.name} service account"
}

resource "google_container_cluster" "primary" {
  name                     = var.name
  location                 = data.google_compute_zones.available.names.0
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary" {
  name       = "${var.name}-primary"
  location   = google_container_cluster.primary.location
  cluster    = google_container_cluster.primary.name
  node_count = 3

  node_config {
    preemptible  = true
    machine_type = var.kubernetes_node_size

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}