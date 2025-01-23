provider "vault" {
  address = var.vault_address
}

resource "null_resource" "set_env_vars" {
  provisioner "local-exec" {
    command = "export VAULT_TOKEN=${var.vault_token}"
  }
}

# Mount KV v2 secrets engine at the specified path
resource "vault_mount" "kv_demo" {
  path        = "engines/demo"
  type        = "kv-v2"
  description = "KV v2 secrets engine for demo"
}

# Write secrets to the specified path
resource "vault_kv_secret_v2" "demo_secrets" {
  mount = vault_mount.kv_demo.path
  name  = "demo_secrets"
  data_json = jsonencode({
    secret1 = "supersecRET1"
    secret2 = "cantguessThis"
  })
}

# Configure the JWT authentication method
resource "vault_jwt_auth_backend" "jwt_demo" {
  description        = "JWT authentication for Vault OIDC Demo"
  path               = var.jwt_mount_path
  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"
}

# Define a role for GitHub Actions
resource "vault_jwt_auth_backend_role" "demo_role" {
  backend         = vault_jwt_auth_backend.jwt_demo.path
  role_name       = "jwt-demo-role"
  role_type       = "jwt"
  bound_audiences = ["https://github.com/${var.github_organization}"]
  user_claim      = "repository"
  bound_claims    = { repository = "${var.github_organization}/${var.github_repo_name}" }
  token_policies  = [vault_policy.read_secrets.name]
}

# Define a policy to allow access to the secrets path
resource "vault_policy" "read_secrets" {
  name   = "read-secrets"
  policy = <<EOT
path "engines/demo/data/demo_secrets" {
  capabilities = ["read"]
}
EOT
}
