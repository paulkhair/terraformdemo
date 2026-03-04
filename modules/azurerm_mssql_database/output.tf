output "sql01" {
  value = azurerm_mssql_server.sql01
}

output "sqldb01" {
  value = azurerm_mssql_database.sqldb01
}

output "private_link_endpoint_ip" {
  value = "${data.azurerm_private_endpoint_connection.calstorage-pe-connection.private_service_connection.0.private_ip_address}"
}

output "Windows_SQL_Server_name" {
  value = "${azurerm_mssql_server.sql01.fully_qualified_domain_name}"
}