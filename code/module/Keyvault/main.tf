# This vault is private-only at the data plane. Terraform can create the Azure
# resource through Azure Resource Manager; subsequent data-plane operations must
# use the private endpoint path and an identity with an Azure RBAC data role.
resource "azurerm_key_vault" "key_vault" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = true
  public_network_access_enabled = false
  tags                          = var.tags

  network_acls {
    bypass         = "None"
    default_action = "Deny"
  }
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = var.is_manual_private_endpoint_connection
  }

  private_dns_zone_group {
    name                 = "key-vault"
    private_dns_zone_ids = var.private_dns_zone_ids
  }
}
