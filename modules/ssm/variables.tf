variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "parameters" {
  description = "Map of parameters to be created in SSM. The key must begin with / (e.g., /database/password)"
  type = map(object({
    value       = string
    type        = string # String or SecureString
    description = string
  }))
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}
