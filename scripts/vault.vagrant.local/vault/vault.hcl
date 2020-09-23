listener "tcp" {
  address = "192.168.33.11:8200"
  tls_disable = true
}

storage "file" {
  path = "/var/lib/vault"
}

api_addr = "http://192.168.33.11:8200"
ui = true