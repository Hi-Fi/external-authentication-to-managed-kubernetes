locals {
  cluster_issuer = "certificate-letsencrypt-staging"
  # Comma has to be escaped, as otherwise Terraform things that's second object to parse
  extra_query = length(var.weavescope_allowed_groups) == 0 ? "" : "?allowed_groups=${join("\\,", var.weavescope_allowed_groups)}"
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "weavescope" {
  source = "../../helm"

  name          = "weavescope"
  repository    = "https://city-of-helsinki.github.io/helm-charts"
  chart         = "weavescope"
  namespace     = kubernetes_namespace.this.id
  chart_version = "0.1.2"

  set = merge(
    {
      "ingress.enabled"                                                   = "true"
      "ingress.hosts[0].host"                                             = "weavescope.${var.base_domain}"
      "ingress.hosts[0].paths[0]"                                         = "/"
      "ingress.tls[0].hosts[0]"                                           = "weavescope.${var.base_domain}"
      "ingress.tls[0].secretName"                                         = "weavescope-tls"
      "ingress.annotations.cert-manager\\.io/cluster-issuer"              = local.cluster_issuer
      "ingress.annotations.kubernetes\\.io/ingress\\.class"               = "nginx"
      "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-signin" = "https://oauth2-proxy.${var.base_domain}/oauth2/start?rd=https://$host$escaped_request_uri"
      "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-url"    = "https://oauth2-proxy.${var.base_domain}/oauth2/auth${local.extra_query}"
    }
  )
}
