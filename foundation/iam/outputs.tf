output "user_arns" {
  description = "Map of usernames to ARNs"
  value = {
    for username, user in aws_iam_user.users :
    username => user.arn
  }
}

output "service_account_access_keys" {
  description = "Access key IDs for service accounts"
  value = {
    for username, key in aws_iam_access_key.user_keys :
    username => key.id
  }
}

output "service_account_secret_keys" {
  description = "Secret access keys for service accounts"
  value = {
    for username, key in aws_iam_access_key.user_keys :
    username => key.secret
  }
  sensitive = true
}

output "ssm_secret_parameters" {
  description = "Names of the SSM parameters where secrets are stored"
  value       = module.ssm_iam_secrets.parameter_names
}

output "cost_explorer_role_arn" {
  description = "ARN of Cost Explorer Reader role"
  value       = aws_iam_role.cost_explorer_reader.arn
}

output "ec2_projects_role_arn" {
  description = "ARN of EC2 projects role"
  value       = aws_iam_role.ec2_projects.arn
}

output "ec2_projects_instance_profile_name" {
  description = "Name of EC2 projects instance profile"
  value       = aws_iam_instance_profile.ec2_projects.name
}

output "ec2_projects_instance_profile_arn" {
  description = "ARN of EC2 projects instance profile"
  value       = aws_iam_instance_profile.ec2_projects.arn
}

output "github_oidc_provider_arn" {
  description = "ARN of GitHub OIDC identity provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
  description = "ARN of IAM role for GitHub Actions (use this in your workflow)"
  value       = aws_iam_role.github_actions.arn
}

output "github_actions_role_name" {
  description = "Name of IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions.name
}