resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  allowed_groups = "{${join(",", var.allowed_groups)}}"
  cluster_issuer = "certificate-letsencrypt-staging"
}

module "oauth2-proxy" {
  source = "../../helm"

  name          = "oauth2-proxy"
  repository    = "https://city-of-helsinki.github.io/helm-charts"
  chart         = "oauth2-proxy"
  namespace     = kubernetes_namespace.this.id
  chart_version = "7.1.4"

  values = [file("./auth/oauth2-proxy/values.yaml")]

  set = merge({
    "config.whitelistDomains"                              = "{.${var.base_domain}}"
    "config.oidc.issuerURL"                                = var.oidc.endpoint
    "config.oidc.redirectURL"                              = var.oidc.redirectURL
    "ingress.hosts[0]"                                     = "oauth2-proxy.${var.base_domain}"
    "ingress.tls[0].hosts[0]"                              = "oauth2-proxy.${var.base_domain}"
    "ingress.annotations.cert-manager\\.io/cluster-issuer" = local.cluster_issuer
    "ingress.annotations.kubernetes\\.io/ingress\\.class"  = "nginx"
    },
    length(var.allowed_groups) == 0 ? null : { "config.allowedGroups" = local.allowed_groups }
  )

  set_sensitive = {
    "config.clientID"     = var.oidc.client_id
    "config.clientSecret" = var.oidc.client_secret
    "config.cookieSecret" = var.oidc.cookie_secret
  }
}
