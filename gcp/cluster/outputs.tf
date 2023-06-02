output "google_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "Name of Google container cluster"
}

output "google_cluster_location" {
  value       = google_container_cluster.primary.location
  description = "Location of Google container cluster"
}