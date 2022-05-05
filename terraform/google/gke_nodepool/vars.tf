# Google Cloud Project ID/Name
variable "gcloud_project_id" {
  type = string
  description = "Google project ID"
}

# Project variables
variable "cluster_name" {
  type = string
  description = "The name of the Kubernetes cluster"
  default = "primary"
}

# Nodepool name
variable "name" {
  type = string
  description = "The name of the nodepool"
}

# Nodepool size
variable "initial_node_count" {
  type = string
  description = "The initial number of nodes for the pool"
  default = "2"
}

# Autoscaling max nodes
variable "max_node_count" {
  type = string
  description = "Maximum nodes in nodepool"
  default = "3"
}

# Autoscaling min nodes
variable "min_node_count" {
  type = string
  description = "Minimum nodes in nodepool"
  default = "1"
}

# Variables for Kubernetes cluster
variable "machine_type" {
  type = string
  description = "Machine type used in k8s nodepool"
}

variable "cluster" {
  type = string
  description = "Cluster this nodepool belongs to"
}

variable "location" {
  type = string
  description = "Node location"
}

# Variables for nodes
variable "labels" {
  type = map(string)
  description = "The Kubernetes labels to be applied to each node"
  default = {}
}

variable "spot" {
  type = bool
  description = "Use pre-emptible instances"
  default = false
}

variable "taints" {
  type = list(
    object({
      key = string
      value = string
      effect = string
    })
  )
  description = "Set taints on nodes"
  default = []
}

# Kubernetes cluster node version
variable "kubernetes_version" {
  type = string
  description = "The Kubernetes version of the nodes"
  default = null
}

variable "disk_size" {
  type = number
  description = "Boot disk size in Gigabytes"
  default = 100
}
