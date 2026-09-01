# This module intentionally contains only the virtual network. Subnets are
# separate resources because AKS and private endpoints require distinct controls.
resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}
