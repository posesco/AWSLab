output "parameter_arns" {
  description = "ARNs from the created parameters"
  value       = { for k, v in aws_ssm_parameter.this : k => v.arn }
}

output "parameter_names" {
  description = "Names of the created parameters"
  value       = [for k, v in aws_ssm_parameter.this : k]
}
