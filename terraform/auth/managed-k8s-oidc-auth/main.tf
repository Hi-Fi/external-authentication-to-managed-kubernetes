locals {
  dex_clients = concat([
    {
      name          = "gangway"
      client_id     = random_string.gangway_client_id.result
      client_secret = random_password.gangway_client_secret.result
      callbackURLs = [
        "https://gangway.${var.base_domain}/callback"
      ]
    }
    ],
  var.additional_clients)

  helm_dex_clients = flatten([
    for index, dex_client in local.dex_clients : [
      {
        "dex.dexEnvironment.DEX_CLIENT_${index}_CLIENT_ID"     = dex_client.client_id
        "dex.dexEnvironment.DEX_CLIENT_${index}_CLIENT_SECRET" = dex_client.client_secret
        "dex.staticClients[${index}].name"                     = dex_client.name
      },
      [for urlindex, callbackURL in dex_client.callbackURLs : {
        "dex.staticClients[${index}].redirectURIs[${urlindex}]" = callbackURL
        }
      ]
    ]
  ])
  cluster_issuer = "certificate-letsencrypt-staging"
  dex_host       = "dex.${var.base_domain}"
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "random_string" "gangway_client_id" {
  length  = 32
  special = false
}

resource "random_password" "gangway_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "gangway_session_security_key" {
  length  = 32
  special = false
}

module "managed-k8s-oidc-auth" {
  source = "../../helm"

  name          = "managed-k8s-oidc-auth"
  repository    = "https://city-of-helsinki.github.io/helm-charts"
  chart         = "managed-k8s-oidc-auth"
  namespace     = kubernetes_namespace.this.id
  chart_version = "0.1.8"

  values = [file("./auth/managed-k8s-oidc-auth/values.yaml")]

  set = {
    "dex.connectors[0].config.redirectURI"                                 = "https://${local.dex_host}/callback"
    "dex.connectors[0].config.orgs[0].name"                                = var.github_organization
    "dex.ingress.annotations.cert-manager\\.io/cluster-issuer"             = local.cluster_issuer
    "dex.ingress.hosts[0].host"                                            = local.dex_host
    "dex.ingress.tls[0].hosts[0]"                                          = local.dex_host
    "gangway.config.clusterName"                                           = var.gangway_cluster_name
    "gangway.config.apiServerURL"                                          = "https://kube-oidc-proxy.${var.base_domain}"
    "gangway.config.authorizeURL"                                          = "https://${local.dex_host}/auth"
    "gangway.config.tokenURL"                                              = "https://${local.dex_host}/token"
    "gangway.ingress.annotations.cert-manager\\.io/cluster-issuer"         = local.cluster_issuer
    "gangway.ingress.hosts[0].host"                                        = "gangway.${var.base_domain}"
    "gangway.ingress.tls[0].hosts[0]"                                      = "gangway.${var.base_domain}"
    "kube-oidc-proxy.oidc.issuerUrl"                                       = "https://${local.dex_host}"
    "kube-oidc-proxy.oidc.groupsPrefix"                                    = "${var.group_prefix}:"
    "kube-oidc-proxy.ingress.hosts[0].host"                                = "kube-oidc-proxy.${var.base_domain}"
    "kube-oidc-proxy.ingress.annotations.cert-manager\\.io/cluster-issuer" = local.cluster_issuer
    "RBAC.adminGroups"                                                     = "{${var.group_prefix}:${var.admin_group}}"
  }
  set_sensitive = merge({
    "dex.dexEnvironment.GITHUB_CLIENT_ID"     = var.github.client_id
    "dex.dexEnvironment.GITHUB_CLIENT_SECRET" = var.github.client_secret
    "gangway.config.clientID"                 = random_string.gangway_client_id.result
    "gangway.config.clientSecret"             = random_password.gangway_client_secret.result
    "gangway.sessionSecurityKey"              = random_password.gangway_session_security_key.result
    "kube-oidc-proxy.oidc.clientId"           = random_string.gangway_client_id.result
    },
    local.helm_dex_clients...
  )
}
