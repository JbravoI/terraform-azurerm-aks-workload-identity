
# The first infrastructure component. The VNet remains isolated so private
# endpoints, AKS, and Key Vault can be introduced as independent modules.
module "vnet" {
  source = "./module/vnet"

  name_prefix                              = var.name_prefix
  resource_group_name                      = var.resource_group_name
  location                                 = var.location
  address_space                            = var.vnet_address_space
  aks_subnet_address_prefixes              = var.aks_subnet_address_prefixes
  private_endpoint_subnet_address_prefixes = var.private_endpoint_subnet_address_prefixes
  tags                                     = local.tags
}
