output "id" {
  description = "Resource ID of the Key Vault."
  value       = azurerm_key_vault.key_vault.id
}

output "name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.key_vault.name
}

output "uri" {
  description = "Data-plane URI of the Key Vault. Access is private-only."
  value       = azurerm_key_vault.key_vault.vault_uri
}

output "private_endpoint_id" {
  description = "Resource ID of the Key Vault private endpoint."
  value       = azurerm_private_endpoint.key_vault.id
}
