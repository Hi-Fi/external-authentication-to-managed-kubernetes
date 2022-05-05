resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "cert-manager" {
  source = "../../helm"

  name          = "cert-manager"
  repository    = "https://charts.jetstack.io"
  chart         = "cert-manager"
  namespace     = kubernetes_namespace.this.id
  chart_version = "1.8.0"

  set = {
    installCRDs                         = "true"
    "prometheus.servicemonitor.enabled" = "false"
    "global.podSecurityPolicy.enabled"  = var.pod_security_policy_enabled
  }
}

resource "kubernetes_manifest" "cluster_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "certificate-letsencrypt-staging"
    }
    "spec" = {
      "acme" = {
        "email"  = "${var.contact_email}"
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "privateKeySecretRef" = {
          "name" = "certificates-letsencrypt-staging"
        }
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "nginx"
              }
            }
          }
        ]
      }
    }
  }
}
