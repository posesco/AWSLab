output "secret_arns" {
  description = "ARNs of the created SSM parameters"
  value       = module.ssm_secrets.parameter_arns
}

output "secret_names" {
  description = "Names of the created SSM parameters"
  value       = module.ssm_secrets.parameter_names
}
