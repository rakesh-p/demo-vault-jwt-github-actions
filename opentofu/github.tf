# Create the necessary GitHub secrets
provider "github" {
  token = var.github_token # GitHub Personal Access Token (PAT)
}

data "github_repository" "repo" {
  full_name = "${var.github_organization}/${var.github_repo_name}"
}

# The KV pairs defined in the for_each are set as variables for the actions workflow
resource "github_actions_secret" "secrets" {
  for_each = {
    "VAULT_ADDR"      = var.vault_address
    "VAULT_ROLE"      = vault_jwt_auth_backend_role.demo_role.role_name
    "VAULT_AUTH_PATH" = var.jwt_mount_path
  }
  secret_name     = each.key
  plaintext_value = each.value
  repository      = var.github_repo_name
}

