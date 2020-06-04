resource "azurerm_key_vault" "keys" {
  name                        = "${data.terraform_remote_state.main.outputs.prefix}kv"
  location                    = data.terraform_remote_state.main.outputs.location
  resource_group_name         = azurerm_resource_group.project.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  purge_protection_enabled    = false

  sku_name = "standard"

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = {
    environment = "Testing"
  }
}

resource "azurerm_key_vault_access_policy" "default_policy" {
  key_vault_id = azurerm_key_vault.keys.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions         = ["get"]
  secret_permissions      = ["get", "list", "set", "delete"]
  certificate_permissions = ["get"]
  storage_permissions     = ["get"]
}
