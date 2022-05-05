output "cluster_name" {
  value = google_container_cluster.this.name
}

output "client_certificate" {
  value = base64decode(google_container_cluster.this.master_auth.0.client_certificate)
}

output "client_key" {
  value = base64decode(google_container_cluster.this.master_auth.0.client_key)
}

output "cluster_ca_certificate" {
  value = base64decode(google_container_cluster.this.master_auth.0.cluster_ca_certificate)
}

output "endpoint" {
  value = google_container_cluster.this.endpoint
}
