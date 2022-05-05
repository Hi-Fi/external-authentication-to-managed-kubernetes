variable "namespace" {
  type = string
  default = "oauth2-proxy"
}

variable "oidc" {
  type = object({
    client_id = string
    client_secret = string
    cookie_secret = string
    endpoint = string
    redirectURL = string
  })
}

variable "base_domain" {
  type = string
}

variable "allowed_groups" {
  type = list(string)
  default = []
}
