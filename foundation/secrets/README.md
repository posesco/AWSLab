## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | ../../modules/common-tags | n/a |
| <a name="module_ssm_secrets"></a> [ssm\_secrets](#module\_ssm\_secrets) | ../../modules/ssm | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"eu-west-1"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of secrets to be stored in SSM | <pre>map(object({<br/>    value       = string<br/>    description = string<br/>    type        = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | ARNs of the created SSM parameters |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Names of the created SSM parameters |

## Diagram

![Terraform Graph](../../media/secrets_graph.svg)
