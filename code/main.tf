
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

module "key_vault" {
  source = "./module/Keyvault"

  name                                  = var.key_vault_name
  location                              = var.location
  resource_group_name                   = var.resource_group_name
  tenant_id                             = data.azurerm_client_config.current.tenant_id
  private_endpoint_subnet_id            = module.vnet.private_endpoint_subnet_id
  private_dns_zone_ids                  = [module.vnet.key_vault_private_dns_zone_id]
  soft_delete_retention_days            = var.key_vault_soft_delete_retention_days
  is_manual_private_endpoint_connection = var.is_manual_private_endpoint_connection
  tags                                  = local.tags
}
