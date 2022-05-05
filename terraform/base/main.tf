
module "nginx-ingress" {
  source = "./nginx-ingress"

  loadbalancer_ip = var.loadbalancer_ip
  pod_security_policy_enabled = var.pod_security_policy_enabled

  namespace = "nginx-ingress"
}

module "cert-manager" {
  source = "./cert-manager"

  namespace = "cert-manager"
  pod_security_policy_enabled = var.pod_security_policy_enabled
  contact_email = var.contact_email
  
  depends_on = [module.nginx-ingress]
}