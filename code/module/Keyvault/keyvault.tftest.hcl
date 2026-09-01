mock_provider "azurerm" {}

run "enforces_private_recoverable_key_vault" {
  command = plan

  variables {
    name                                  = "exampleakswkv001"
    location                              = "uksouth"
    resource_group_name                   = "rg-example-akswi-dev"
    tenant_id                             = "00000000-0000-0000-0000-000000000000"
    private_endpoint_subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-akswi-dev/providers/Microsoft.Network/virtualNetworks/example-akswi-vnet/subnets/example-akswi-pep-snet"
    private_dns_zone_ids                  = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-akswi-dev/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
    soft_delete_retention_days            = 90
    is_manual_private_endpoint_connection = false
    tags                                  = { environment = "test" }
  }

  assert {
    condition     = azurerm_key_vault.key_vault.rbac_authorization_enabled && azurerm_key_vault.key_vault.purge_protection_enabled
    error_message = "The Key Vault must use Azure RBAC and purge protection."
  }

  assert {
    condition     = azurerm_key_vault.key_vault.public_network_access_enabled == false && azurerm_key_vault.key_vault.network_acls[0].default_action == "Deny"
    error_message = "The Key Vault must deny public data-plane access."
  }

  assert {
    condition     = length(azurerm_private_endpoint.key_vault.private_service_connection[0].subresource_names) == 1 && contains(azurerm_private_endpoint.key_vault.private_service_connection[0].subresource_names, "vault")
    error_message = "The private endpoint must target the Key Vault vault subresource."
  }
}
