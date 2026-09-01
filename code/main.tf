
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

module "aks" {
  source = "./module/AKS"

  name                       = var.aks_name
  dns_prefix                 = var.aks_dns_prefix
  kubernetes_version         = var.aks_kubernetes_version
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  admin_group_object_ids     = var.aks_admin_group_object_ids
  aks_subnet_id              = module.vnet.aks_subnet_id
  pod_cidr                   = var.aks_pod_cidr
  service_cidr               = var.aks_service_cidr
  dns_service_ip             = var.aks_dns_service_ip
  node_vm_size               = var.aks_node_vm_size
  node_min_count             = var.aks_node_min_count
  node_max_count             = var.aks_node_max_count
  node_max_pods              = var.aks_node_max_pods
  log_analytics_workspace_id = var.aks_log_analytics_workspace_id
  tags                       = local.tags
}
