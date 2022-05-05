variable "namespace" {
  type    = string
  default = "weavescope"
}

variable "base_domain" {
  type = string
}

variable "weavescope_allowed_groups" {
  type    = list(string)
  default = []
}
