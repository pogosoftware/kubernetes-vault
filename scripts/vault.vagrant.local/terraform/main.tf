provider "vault" {
  address = "http://192.168.33.11:8200"
  token = "VAULT_TOKEN"
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "example" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = "https://192.168.33.10:16443"
  kubernetes_ca_cert = file("/vagrant/secrets/vault_agent.crt")
  token_reviewer_jwt = file("/vagrant/secrets/vault_agent.token")
}

resource "vault_mount" "internal" {
  path        = "internal"
  type        = "kv"
  description = "This is an example mount"
  options = {
    version = 2
  }
}

resource "vault_generic_secret" "example" {
  path = join("/", [vault_mount.internal.path, "database/config"])

  data_json = <<EOT
{
  "username":   "db-readonly-username",
  "password": "db-secret-password"
}
EOT
}

resource "vault_policy" "internal_app" {
  name = "internal-app"

  policy = <<EOT
path "internal/data/database/config" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "internal_app" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "internal-app"
  bound_service_account_names      = ["internal-app"]
  bound_service_account_namespaces = ["default"]
  token_ttl                        = 86400
  token_policies                   = [vault_policy.internal_app.name]
}