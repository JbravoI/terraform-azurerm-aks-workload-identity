output "id" {
  description = "Resource ID of the virtual network."
  value       = azurerm_virtual_network.vnet.id
}

output "name" {
  description = "Name of the virtual network."
  value       = azurerm_virtual_network.vnet.name
}

output "address_space" {
  description = "Address spaces assigned to the virtual network."
  value       = azurerm_virtual_network.vnet.address_space
}

output "aks_subnet_id" {
  description = "Resource ID of the dedicated AKS node subnet."
  value       = azurerm_subnet.aks.id
}

output "aks_subnet_name" {
  description = "Name of the dedicated AKS node subnet."
  value       = azurerm_subnet.aks.name
}

output "aks_subnet_address_prefixes" {
  description = "Address prefixes assigned to the dedicated AKS node subnet."
  value       = azurerm_subnet.aks.address_prefixes
}

output "private_endpoint_subnet_id" {
  description = "Resource ID of the dedicated private-endpoint subnet."
  value       = azurerm_subnet.private_endpoints.id
}

output "private_endpoint_subnet_name" {
  description = "Name of the dedicated private-endpoint subnet."
  value       = azurerm_subnet.private_endpoints.name
}

output "private_endpoint_subnet_address_prefixes" {
  description = "Address prefixes assigned to the dedicated private-endpoint subnet."
  value       = azurerm_subnet.private_endpoints.address_prefixes
}
