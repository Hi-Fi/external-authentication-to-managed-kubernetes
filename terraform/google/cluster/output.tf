output "cluster_name" {
  value = module.master.cluster_name
}

output "cluster_ca_certificate" {
  value = module.master.cluster_ca_certificate
}

output "client_certificate" {
  value = module.master.client_certificate
}

output "client_key" {
  value = module.master.client_key
}

output "endpoint" {
  value = module.master.endpoint
}

output "ingress_ip" {
  value = google_compute_address.ingress.address
}
