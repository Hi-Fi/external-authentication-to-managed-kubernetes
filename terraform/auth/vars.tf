variable "oauth_client_id" {
  sensitive = true
  type = string
}

variable "oauth_client_secret" {
  sensitive = true
  type = string
}

variable "base_domain" {
  type = string
}

variable "gangway_cluster_name" {
  type = string
}

variable "github_organization" {
  
}

variable "admin_group" {
  
}
