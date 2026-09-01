output "vnet_id" {
  description = "Resource ID of the virtual network created by this configuration."
  value       = module.vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network created by this configuration."
  value       = module.vnet.name
}

output "vnet_address_space" {
  description = "Address spaces assigned to the virtual network."
  value       = module.vnet.address_space
}

output "aks_subnet_id" {
  description = "Resource ID of the dedicated AKS node subnet."
  value       = module.vnet.aks_subnet_id
}

output "aks_subnet_name" {
  description = "Name of the dedicated AKS node subnet."
  value       = module.vnet.aks_subnet_name
}

output "aks_subnet_address_prefixes" {
  description = "Address prefixes assigned to the dedicated AKS node subnet."
  value       = module.vnet.aks_subnet_address_prefixes
}

output "private_endpoint_subnet_id" {
  description = "Resource ID of the dedicated private-endpoint subnet."
  value       = module.vnet.private_endpoint_subnet_id
}

output "private_endpoint_subnet_name" {
  description = "Name of the dedicated private-endpoint subnet."
  value       = module.vnet.private_endpoint_subnet_name
}

output "private_endpoint_subnet_address_prefixes" {
  description = "Address prefixes assigned to the dedicated private-endpoint subnet."
  value       = module.vnet.private_endpoint_subnet_address_prefixes
}

output "key_vault_private_dns_zone_id" {
  description = "Resource ID of the Azure Key Vault private DNS zone."
  value       = module.vnet.key_vault_private_dns_zone_id
}

output "key_vault_private_dns_zone_name" {
  description = "Name of the Azure Key Vault private DNS zone."
  value       = module.vnet.key_vault_private_dns_zone_name
}

output "key_vault_private_dns_zone_vnet_link_id" {
  description = "Resource ID of the Azure Key Vault private DNS zone VNet link."
  value       = module.vnet.key_vault_private_dns_zone_vnet_link_id
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault."
  value       = module.key_vault.id
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "Data-plane URI of the Key Vault. Access is private-only."
  value       = module.key_vault.uri
}

output "key_vault_private_endpoint_id" {
  description = "Resource ID of the Key Vault private endpoint."
  value       = module.key_vault.private_endpoint_id
}
