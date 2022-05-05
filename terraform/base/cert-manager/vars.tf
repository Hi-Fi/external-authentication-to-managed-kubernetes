variable "namespace" {
  type = string
}

variable "pod_security_policy_enabled" {
  type = string
}

variable "contact_email" {
  type = string
  description = "Contact email for Let's Encrypt ACME registration"
}