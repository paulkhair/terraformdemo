locals {
  assetname   = "ProjectName"
  environment = "dev"
  location    = "westeurope"

  resource_name = format("%s-%s-%s", local.assetname, local.environment, local.location)
}

resource "azurerm_resource_group" "resourcegroup" {
  name     = "${local.resource_name}-rg-main"
  location = local.location
}

module "azurerm_key_vault" {
  source = "./modules/azurerm_key_vault"
  resource_group_name     = azurerm_resource_group.resourcegroup.name
  resource_group_location = azurerm_resource_group.resourcegroup.location
  assetname               = local.assetname
  environment             = local.environment
}

module "azurerm_storage_accounts" {
  source = "./modules/azurerm_storage_account"

  resource_group_name     = azurerm_resource_group.resourcegroup.name
  resource_group_location = azurerm_resource_group.resourcegroup.location
  assetname               = local.assetname
  environment             = local.environment
  instance_count          = 1
}
/*
module "azurerm_service_plan" {
  source = "./modules/azurerm_service_plan"
  resource_group_name     = azurerm_resource_group.resourcegroup.name
  resource_group_location = azurerm_resource_group.resourcegroup.location
  assetname               = local.assetname
  environment             = local.environment
  instance_count          = 1
}

module "azurerm_mssql_database" {
  source = "./modules/azurerm_mssql_database"
  resource_group_name     = azurerm_resource_group.resourcegroup.name
  resource_group_location = azurerm_resource_group.resourcegroup.location
  assetname               = local.assetname
  environment             = local.environment
  #instance_count          = 1
}
*/


