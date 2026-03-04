locals {
sa_name = format("sa%s%s", var.assetname, var.environment)
}

resource "azurerm_storage_account" "storageaccount" {
  #count = var.instance_count

  name                      = "${local.sa_name}001"
  resource_group_name       = var.resource_group_name
  location                  = var.resource_group_location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  public_network_access_enabled = false
  allow_nested_items_to_be_public = false

  tags = {
    environment = var.environment
  }

  lifecycle { ##This is a hack to deal with policy deadlock##
    ignore_changes = [
    public_network_access_enabled,
    allow_nested_items_to_be_public,
    ]
  }
}


resource "azurerm_storage_container" "container01" {
  name                  = "container01"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container02" {
  name                  = "container02"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container03" {
  name                  = "container03"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}
