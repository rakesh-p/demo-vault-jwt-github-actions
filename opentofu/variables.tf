variable "vault_address" {
  description = "(Required) The address of the Hashicorp vault server to be used"
  type        = string
}

variable "vault_token" {
  description = "(Required) Hashicorp Vault token"
  type        = string
  sensitive   = true
}

variable "jwt_mount_path" {
  description = "(Optional) Path in vault to mount the JWT auth method"
  type        = string
  default     = "jwt_demo"
}

variable "github_organization" {
  type        = string
  description = "(Required) The GitHub organization or username"
}

variable "github_repo_name" {
  type        = string
  description = "(Required) The GitHub repository"
}

variable "github_token" {
  description = "(Required) GitHub personal access token"
  type        = string
  sensitive   = true
}
