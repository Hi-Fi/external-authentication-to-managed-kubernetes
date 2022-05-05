variable "name" {
  description = "Prefix added to resource names"
  default     = "demo"
  type        = string
}

variable "project_id" {
  description = "Google Cloud Platform project ID"
  type        = string
}

variable "region" {
  type = string
}

variable "zone" {
  type        = string
  default     = ""
  description = "Zone to create cluster to. If empty, regional cluster is created"
}


variable "ip_cidr_block" {
  type    = string
  default = "10.20.0.0/16"
}

variable "kubernetes_version_prefix" {
  type = string
}

variable "pod_security_policy_enabled" {
  default = false
}
