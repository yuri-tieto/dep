resource "random_password" "admin_password" {
  length      = 20
  special     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "vm-admin-password"
  value        = random_password.admin_password.result
  key_vault_id = azurerm_key_vault.keys.id
  depends_on   = [azurerm_key_vault_access_policy.default_policy]

  tags = {
    environment = "Testing"
  }
}
