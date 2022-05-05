variable "namespace" {
  default = "auth"
}

variable "github" {
  type = object({
    client_id = string
    client_secret = string
  })
  description = "Dex connector to Github"
}

variable "gangway_cluster_name" {
  type = string
  description = "Gangway shown cluster name"
}

variable "base_domain" {
  type = string
}

variable "additional_clients" {
  type = list(object({
    name = string
    client_id = string
    client_secret = string
    callbackURLs = list(string)
  }))
  default = []
}

variable "github_organization" {
  
}

variable "admin_group" {
  
}

variable "group_prefix" {
  description = "Prefix that's used in groups to prevent collissions with existing groups"
  default = "dex"  
}