data "google_container_engine_versions" "this" {
  provider       = google-beta
  location       = local.zone
  version_prefix = "${var.kubernetes_version_prefix}."
  project        = var.project_id
}

locals {
  zone        = var.zone == "" ? var.region : var.zone
  k8s_version = data.google_container_engine_versions.this.release_channel_default_version["RAPID"]
}

resource "google_compute_address" "ingress" {
  project      = var.project_id
  name         = "${var.name}-ingress"
  description  = "Static ip ingress"
  region       = var.region
  address_type = "EXTERNAL"
}

module "vpc" {
  source     = "../vpc"
  project_id = var.project_id
}

module "master" {
  source = "../gke_master"

  cluster_name      = "${var.name}-master"
  gcloud_project_id = var.project_id
  gke_location      = local.zone

  network            = module.vpc.network
  kubernetes_version = local.k8s_version
  subnet             = module.vpc.subnet

  pod_security_policy_enabled = var.pod_security_policy_enabled
}

#########
# Nodes #
#########

module "demopool" {
  source = "../gke_nodepool"

  gcloud_project_id = var.project_id
  cluster           = module.master.cluster_name
  location          = local.zone
  machine_type      = "e2-custom-2-8192"
  name              = "demopool"
  spot              = true
  disk_size         = 100

  # Autoscaling
  initial_node_count = 1
  min_node_count     = 1
  max_node_count     = 3
  kubernetes_version = local.k8s_version
}
