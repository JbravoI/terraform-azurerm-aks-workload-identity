# This module intentionally contains only the virtual network. 
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

# AKS worker nodes use this subnet. 
resource "azurerm_subnet" "aks" {
  name                 = local.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aks_subnet_address_prefixes
}

# Private endpoints are the only intended occupants of this subnet. Network
# policies are explicitly disabled because this reference pattern uses private
# endpoints without NSG or route-table policy enforcement on that subnet.
resource "azurerm_subnet" "private_endpoints" {
  name                              = local.private_endpoint_subnet_name
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = var.private_endpoint_subnet_address_prefixes
  private_endpoint_network_policies = "Disabled"
}
