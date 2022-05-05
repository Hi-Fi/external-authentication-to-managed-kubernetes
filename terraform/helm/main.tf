resource "helm_release" "release" {
  name       = var.name
  repository = var.repository
  chart      = var.chart
  namespace  = var.namespace
  version    = var.chart_version
  timeout    = var.timeout

  atomic = var.atomic

  values = var.values

  dynamic "set" {
    for_each = var.set
    iterator = it
    content {
      name  = it.key
      value = it.value
    }
  }

  dynamic "set" {
    for_each = var.set_string
    iterator = it
    content {
      name  = it.key
      value = it.value
      type  = "string"
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive
    iterator = it
    content {
      name  = it.key
      value = it.value
    }
  }
}
