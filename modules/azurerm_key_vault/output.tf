output "akv01" {
  value = azurerm_key_vault.akv01
}

output "calstoragedbsvrpass" {
  value     = data.azurerm_key_vault_secret.calstoragedbsvrpass.value
  sensitive = true
}
