variable "name" {
  type = string
}

variable "repository" {
  type = string
}

variable "chart" {
  type = string
}

variable "namespace" {
  type = string
}

variable "chart_version" {
  type = string
}

variable "atomic" {
  description = "If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used"
  type        = bool
  default     = true
}

variable "values" {
  description = "values as raw YAML to be used in installation. Can be read e.g. from file"
  type        = list(any)
  default     = []
}

variable "set" {
  default = []
}

variable "set_string" {
  description = "values that need to be forced to be as strings"
  default     = []
}

variable "set_sensitive" {
  description = "sensitive values (not logged in output)"
  default     = []
}

variable "timeout" {
  default = 300
}
