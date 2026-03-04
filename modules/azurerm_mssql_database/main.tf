locals {
sql_name = format("sqlsvr%s%s", var.assetname, var.environment)
sqldb_name = format("sqldb%s%s", var.assetname, var.environment)
pe_name = format("pe%s%s00", var.assetname, var.environment)
}

resource "azurerm_mssql_server" "sql01" {
  #count = var.instance_count
  name                      = "${local.sql_name}"
  resource_group_name       = var.resource_group_name
  location                  = var.resource_group_location
  version                      = "12.0"
  public_network_access_enabled        = false
  administrator_login          = "azureuser"
  administrator_login_password = data.azurerm_key_vault_secret."put_your_secret_name_from_Azure_keyvault".value

  tags = {
    environment = var.environment
  }
}

resource "azurerm_mssql_database" "sqldb01" {
  name                      = "${local.sqldb_name}"
  server_id           = azurerm_mssql_server.sql01.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  #license_type   = "BasePrice"
  max_size_gb    = 32
  #read_scale     = true
  sku_name       = "GP_Gen5_2"
  zone_redundant = false
  storage_account_type = "Local"
  tags = {
    environment = var.environment
  }
}

# Create a DB Private Endpoint
resource "azurerm_private_endpoint" "pe01" {
  name = "${local.pe_name}1"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id = data.azurerm_subnet.subnet3.id
  private_service_connection {
    name = "${local.sql_name}plink"
    is_manual_connection = "false"
    private_connection_resource_id = azurerm_mssql_server.sql01.id
    subresource_names = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [
        azurerm_private_dns_zone.pepdns.id
    ]
  }      
  tags = {
    environment = var.environment
  }
}

# DB Private Endpoint Connecton
data "azurerm_private_endpoint_connection" "pe-connection01" {
  name = azurerm_private_endpoint.pe01.name
  resource_group_name = var.resource_group_name  
}

resource "azurerm_private_dns_zone" "pepdns" {
  name                = "database.windows.net"
  resource_group_name = var.resource_group_name
  tags = {
    environment = var.environment
  }
}

# Create a DB Private DNS A Record
resource "azurerm_private_dns_a_record" "pe-a-record" {
  name = azurerm_mssql_server.sql01.name
  zone_name = azurerm_private_dns_zone.pepdns.name
  resource_group_name = var.resource_group_name
  ttl = 10
  records = [data.azurerm_private_endpoint_connection.pe-connection01.private_service_connection.0.private_ip_address]
}

resource "azurerm_private_dns_zone_virtual_network_link" "pepdns-link" {
  name = "pepdns-link"
  resource_group_name = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pepdns.name
  virtual_network_id = data.azurerm_virtual_network.vnet01.id
  tags = {
    environment = var.environment
  }
}




#####  Reference Data already created outside terraform  ##
/*
data "azurerm_virtual_network" "vnet01" {
  name                = "vnet-8a37bca2-bfab-4c1d-b53b-96709c40c203"
  resource_group_name = "pace-default-rg"
}
data "azurerm_subnet" "subnet2" {
  name                = "Subnet2"
  virtual_network_name = data.azurerm_virtual_network.vnet01.name
  resource_group_name = "pace-default-rg"
}

data "azurerm_subnet" "subnet3" {
  name                = "Subnet3"
  virtual_network_name = data.azurerm_virtual_network.vnet01.name
  resource_group_name = "pace-default-rg"
}
data "azurerm_key_vault" "akv01" {
  name                = "akvcalstorageprod"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "calstoragedbsvrpass" {
  name                = "calstoragedbsvrpass"
  key_vault_id = data.azurerm_key_vault.akv01.id
}
*/