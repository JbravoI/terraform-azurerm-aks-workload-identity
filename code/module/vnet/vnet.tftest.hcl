mock_provider "azurerm" {}

run "enforces_network_separation" {
  command = plan

  variables {
    name_prefix                              = "example-akswi"
    resource_group_name                      = "rg-example-akswi-dev"
    location                                 = "uksouth"
    address_space                            = ["10.40.0.0/16"]
    aks_subnet_address_prefixes              = ["10.40.0.0/20"]
    private_endpoint_subnet_address_prefixes = ["10.40.16.0/24"]
    tags                                     = { environment = "test" }
  }

  assert {
    condition     = azurerm_subnet.private_endpoints.private_endpoint_network_policies == "Disabled"
    error_message = "The private-endpoint subnet must disable private endpoint network policies for this reference pattern."
  }

  assert {
    condition     = azurerm_private_dns_zone.key_vault.name == "privatelink.vaultcore.azure.net"
    error_message = "Key Vault private endpoints require the privatelink.vaultcore.azure.net private DNS zone."
  }

  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.key_vault.registration_enabled == false
    error_message = "Private Link DNS zones must not use VM auto-registration."
  }
}
