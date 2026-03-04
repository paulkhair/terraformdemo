locals {
akv_name = format("akv%s%s", var.assetname, var.environment)
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "akv01" {
  #count = var.instance_count
  name                      = "${local.akv_name}"
  resource_group_name       = var.resource_group_name
  location                  = var.resource_group_location
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "GetRotationPolicy",
      "SetRotationPolicy",
      "Rotate",
    
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]

    storage_permissions = [
      "Get",
    ]
    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
    ]
    
  }

  tags = {
    environment = var.environment
  }
}

#####  Reference Data already created outside terraform  ##
/*
data "azurerm_key_vault_secret" "Secret01" {
  name                = "put_the_secret_name"
  key_vault_id = azurerm_key_vault.akv01.id
}
*/