# Project variables
variable "cluster_name" {
  type = string
  description = "The name of the Kubernetes cluster"
  default = "primary"
}

# Google Cloud Project ID/Name
variable "gcloud_project_id" {
  type = string
  description = "Google project ID"
}

# Variables for Kubernetes cluster
variable "gke_location" {
  type = string
  description = "Location of the cluster ie. europe-north1, europe-north1-a"
}

# Kubernetes cluster node version
variable "kubernetes_version" {
  type = string
  description = "The Kubernetes version of the master (and nodes)"
  default = null
}

variable "network" {
  type = string
  description = "The name or self_link of the Google Compute Engine network to which the cluster is connected"
}

variable "subnet" {
  type = string
  description = "The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched"
}

variable "pod_security_policy_enabled" {
  type = bool
  description = "Enable the PodSecurityPolicy controller for this cluster"
  default = false
}
