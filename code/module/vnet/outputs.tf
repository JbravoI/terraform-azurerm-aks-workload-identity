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
