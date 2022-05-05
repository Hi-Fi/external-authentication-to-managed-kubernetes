variable "loadbalancer_ip" {
  type = string
}

variable "pod_security_policy_enabled" {
  type    = bool
  default = false
}

variable "contact_email" {
  type = string
  description = "Contact email for Let's Encrypt ACME registration"
}