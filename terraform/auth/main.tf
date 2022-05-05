resource "random_string" "oauth2_proxy_client_id" {
  length  = 32
  special = false
}

resource "random_password" "oauth2_proxy_client_secret" {
  length  = 32
  special = false
}

resource "random_password" "oauth2_proxy_cookie_secret" {
  length  = 32
  special = false
}

locals {
  oauth2_proxy_redirectURL = "https://oauth2-proxy.${var.base_domain}/oauth2/callback"
}

module "managed-k8s-oidc-auth" {
  source = "./managed-k8s-oidc-auth"
  # Cert-manager CRDs must be installed first

  github = {
    client_id     = var.oauth_client_id
    client_secret = var.oauth_client_secret
  }
  gangway_cluster_name = var.gangway_cluster_name
  additional_clients = [
    {
      name          = "oauth2-proxy"
      client_id     = random_string.oauth2_proxy_client_id.result
      client_secret = random_password.oauth2_proxy_client_secret.result
      callbackURLs = [
        local.oauth2_proxy_redirectURL
      ]
    }
  ]

  base_domain         = var.base_domain
  github_organization = var.github_organization
  admin_group         = var.admin_group
}

module "oauth2-proxy" {
  count  = var.gangway_cluster_name != null ? 1 : 0
  source = "./oauth2-proxy"
  # Requires DEX client to be created
  depends_on = [
    module.managed-k8s-oidc-auth
  ]

  oidc = {
    client_id     = random_string.oauth2_proxy_client_id.result
    client_secret = random_password.oauth2_proxy_client_secret.result
    cookie_secret = random_password.oauth2_proxy_cookie_secret.result
    endpoint      = "https://${module.managed-k8s-oidc-auth.dex_host}"
    redirectURL   = local.oauth2_proxy_redirectURL
  }

  base_domain = var.base_domain
  allowed_groups = [
    var.admin_group
  ]
}
