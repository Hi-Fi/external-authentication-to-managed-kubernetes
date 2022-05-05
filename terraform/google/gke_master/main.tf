#=============================
# Google project configuration
#=============================
data "google_project" "this" {
  project_id = var.gcloud_project_id
}

#========================================
# Master kubernetes cluster configuration
#========================================
resource "google_container_cluster" "this" {
  provider = google-beta
  lifecycle {
    prevent_destroy = false
  }

  project = var.gcloud_project_id
  name = var.cluster_name
  location = var.gke_location

  network = var.network
  subnetwork = var.subnet

  initial_node_count = 1
  remove_default_node_pool = true
  min_master_version = var.kubernetes_version

  workload_identity_config {
    workload_pool = "${data.google_project.this.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "RAPID"
  }

  # =============
  # Beta features
  # =============
  enable_shielded_nodes = true

  network_policy {
    enabled = true
  }

  vertical_pod_autoscaling {
    enabled = false
  }

  pod_security_policy_config {
    enabled = var.pod_security_policy_enabled
  }

  addons_config {
    dns_cache_config {
      enabled = false
    }
  }
}
