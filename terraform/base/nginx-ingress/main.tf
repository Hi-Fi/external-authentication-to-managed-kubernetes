resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      ingress = "default"
    }
    name = var.namespace
  }
}


module "nginx-ingress" {
  source = "../../helm"

  name          = "nginx-ingress"
  repository    = "https://kubernetes.github.io/ingress-nginx"
  chart         = "ingress-nginx"
  namespace     = kubernetes_namespace.this.id
  chart_version = "4.1.0"

  values = [file("base/nginx-ingress/values.yml")]

  set = {
    "controller.service.loadBalancerIP" = var.loadbalancer_ip
    "defaultBackend.enabled"            = "true"
    "podSecurityPolicy.enabled"         = var.pod_security_policy_enabled
  }
}
