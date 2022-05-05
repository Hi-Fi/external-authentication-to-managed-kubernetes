module "weavescope" {
  source = "./weavescope"

  base_domain               = var.base_domain
  weavescope_allowed_groups = var.weavescope_allowed_groups
}
