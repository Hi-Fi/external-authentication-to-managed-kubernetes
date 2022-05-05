#==================================
# Kubernetes nodepool configuration
#==================================
resource "google_container_node_pool" "this" {
  provider = google-beta
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      initial_node_count
    ]
  }

  project  = var.gcloud_project_id
  name     = var.name
  cluster  = var.cluster
  location = var.location

  version = var.kubernetes_version

  initial_node_count = var.initial_node_count
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  node_config {
    image_type   = "COS_CONTAINERD"
    machine_type = var.machine_type
    disk_size_gb = var.disk_size
    labels       = var.labels
    spot         = var.spot

    kubelet_config {
      cpu_manager_policy = "none"
      cpu_cfs_quota      = false
    }

    dynamic "taint" {
      for_each = var.taints
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = false
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
}
