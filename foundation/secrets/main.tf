locals {
  env         = terraform.workspace
  common_tags = module.common_tags.tags
}

module "common_tags" {
  source  = "../../modules/common-tags"
  env     = local.env
  project = "foundation"
  additional_tags = {
    Component = "secrets-management"
  }
}

module "ssm_secrets" {
  source = "../../modules/ssm"

  aws_region  = var.aws_region
  parameters  = var.secrets
  common_tags = local.common_tags
}
