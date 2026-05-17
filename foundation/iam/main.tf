module "common_tags" {
  source  = "../../modules/common-tags"
  env     = "global"
  project = "foundation"
  additional_tags = {
    Component = "iam"
  }
}

data "aws_iam_policy_document" "cost_explorer_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        for username in keys(local.service_accounts) :
        aws_iam_user.users[username].arn
      ]
    }

    actions = ["sts:AssumeRole"]

  }
}
locals {
  common_tags = module.common_tags.tags
  service_accounts = {
    for username, config in var.iam_users :
    username => config if config.create_access_key
  }
  console_users = {
    for username, config in var.iam_users :
    username => config if config.console_access
  }

  ssm_parameters = {
    for username in keys(local.service_accounts) :
    "iam/access_keys/${username}/secret" => {
      value       = aws_iam_access_key.user_keys[username].secret
      type        = "SecureString"
      description = "Secret access key for ${username}"
    }
  }
}

module "ssm_iam_secrets" {
  source = "../../modules/ssm"

  aws_region  = var.aws_region
  parameters  = local.ssm_parameters
  common_tags = local.common_tags
}