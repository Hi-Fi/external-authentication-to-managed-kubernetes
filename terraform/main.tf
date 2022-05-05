#############
# Providers #
#############
provider "helm" {
  kubernetes {
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = module.k8s.cluster_ca_certificate
    client_certificate     = module.k8s.client_certificate
    client_key             = module.k8s.client_key
    host                   = module.k8s.endpoint
  }
}

# GKE
provider "kubernetes" {
  host                   = "https://${module.k8s.endpoint}:443"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = module.k8s.cluster_ca_certificate
  client_certificate     = module.k8s.client_certificate
  client_key             = module.k8s.client_key
}

##########
# Locals #
##########

locals {
  base_domain = "${module.k8s.ingress_ip}.nip.io"
}

#############
# Resources #
#############

data "google_client_config" "default" {

}

module "k8s" {
  source = "./google/cluster"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  kubernetes_version_prefix = var.kubernetes_version_prefix
}

module "base" {
  source          = "./base"
  loadbalancer_ip = module.k8s.ingress_ip
  contact_email   = var.email
}

module "auth" {
  # Base things need to be installed before, as we need both ingress and cert-manager
  depends_on = [
    module.base
  ]
  source               = "./auth"
  oauth_client_id      = var.client_id
  oauth_client_secret  = var.client_secret
  gangway_cluster_name = "demo"
  base_domain          = local.base_domain
  github_organization  = var.github_organization
  admin_group          = var.admin_group
}

module "monitoring" {
  # Base things need to be installed before, as we need both ingress and cert-manager
  depends_on = [
    module.base
  ]
  source      = "./monitoring"
  base_domain = local.base_domain

  weavescope_allowed_groups = [
    var.admin_group
  ]
}
