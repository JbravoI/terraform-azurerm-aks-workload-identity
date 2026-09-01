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
