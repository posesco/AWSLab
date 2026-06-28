variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "hermes"
}

variable "allowed_ssh_cidr_ipv4" {
  type        = string
  description = "CIDR block allowed for SSH access (IPv4)"
  default     = null
  nullable    = true

  validation {
    condition = (
      var.allowed_ssh_cidr_ipv4 == null ||
      (can(cidrhost(var.allowed_ssh_cidr_ipv4, 0)) && var.allowed_ssh_cidr_ipv4 != "0.0.0.0/0")
    )
    error_message = "allowed_ssh_cidr_ipv4 must be a valid CIDR and must not be 0.0.0.0/0."
  }
}

variable "allowed_ssh_cidr_ipv6" {
  type        = string
  description = "CIDR block allowed for SSH access (IPv6)"
  default     = null
  nullable    = true

  validation {
    condition = (
      var.allowed_ssh_cidr_ipv6 == null ||
      (can(cidrhost(var.allowed_ssh_cidr_ipv6, 0)) && var.allowed_ssh_cidr_ipv6 != "::/0")
    )
    error_message = "allowed_ssh_cidr_ipv6 must be a valid CIDR and must not be ::/0."
  }
}

variable "enable_ssh_access" {
  type        = bool
  description = "Whether to allow direct SSH ingress. Prefer SSM Session Manager or Cloudflare Tunnel; enable only with narrow CIDRs."
  default     = false
}

variable "instance_type" {
  type        = map(string)
  description = "EC2 instance type"
  default = {
    dev     = "t4g.small"
    staging = "t4g.medium"
    prod    = "t4g.large"
  }
  validation {
    condition = alltrue([
      for value in values(var.instance_type) :
      can(regex("^[a-z][a-z0-9]*g[d]?\\.(nano|micro|small|medium|large|xlarge|[0-9]+xlarge)$", value))
    ])
    error_message = "Only ARM64 (Graviton) instance types allowed (e.g., t4g.small, m6g.large, c7gd.xlarge)."
  }
}

variable "key_name" {
  type        = map(string)
  description = "Name of the SSH key pair in AWS"
  default = {
    dev     = "keypair_dev"
    staging = "keypair_staging"
    prod    = "keypair_prod"
  }
  validation {
    condition     = alltrue([for value in values(var.key_name) : value != ""])
    error_message = "All key_name values must be non-empty strings."
  }
}

variable "lab_volume_size" {
  type        = map(number)
  description = "Size of the root volume in GB"
  default = {
    dev     = 20
    staging = 50
    prod    = 50
  }
  validation {
    condition     = alltrue([for value in values(var.lab_volume_size) : value > 10])
    error_message = "All lab_volume_size values must be greater than 10 GB."
  }
}

variable "cloudflare_tunnel_token_parameter_name" {
  type        = map(string)
  description = "SSM SecureString parameter name containing the Cloudflare Tunnel token per environment."
  default = {
    dev     = "/hermes/dev/cloudflare_token"
    staging = "/hermes/staging/cloudflare_token"
    prod    = "/hermes/prod/cloudflare_token"
  }

  validation {
    condition = alltrue([
      for parameter_name in values(var.cloudflare_tunnel_token_parameter_name) :
      can(regex("^/[^*]+/[^/]+$", parameter_name)) && trimsuffix(parameter_name, "/") == parameter_name
    ])
    error_message = "Cloudflare tunnel token SSM parameter names must be absolute paths without wildcards and must include a final parameter name segment."
  }
}
