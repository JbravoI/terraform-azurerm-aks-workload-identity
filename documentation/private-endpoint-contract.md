# Private Endpoint Contract

**Status:** Implemented by `code/module/Keyvault/` in Phase 4.

## Purpose

This contract standardises private endpoint inputs so the Key Vault private endpoint can be implemented without hard-coding VNet, subnet, or DNS details. The first implementation is in `code/module/Keyvault/` and creates an Azure Key Vault private endpoint only after creating its target Key Vault.

## Required interface

| Input | Type | Source in this repository | Purpose |
|---|---|---|---|
| `name_prefix` | `string` | Root naming input | Creates the endpoint and connection names. |
| `location` | `string` | Root location input | Azure location for the endpoint. |
| `resource_group_name` | `string` | Root resource-group input | Resource group containing the endpoint. |
| `subnet_id` | `string` | `module.vnet.private_endpoint_subnet_id` | Dedicated subnet for the endpoint NIC. |
| `private_connection_resource_id` | `string` | Target service resource ID | Resource to connect privately, for example Key Vault ID. |
| `subresource_names` | `list(string)` | Service-specific constant | Private Link subresource; Key Vault uses `["vault"]`. |
| `private_dns_zone_ids` | `list(string)` | `module.vnet.key_vault_private_dns_zone_id` | Zone IDs placed in the private DNS zone group. |
| `is_manual_connection` | `bool` | Default `false` for same-tenant Key Vault | Whether the remote owner must approve the connection. |
| `tags` | `map(string)` | Root tags local | Standard resource tags. |

## Implementation requirements

- The private endpoint must use `azurerm_private_endpoint` and the dedicated private-endpoint subnet only.
- The `private_service_connection` must specify an intentional connection name, target resource ID, subresource names, and approval mode.
- The `private_dns_zone_group` must attach the supplied private DNS zone IDs; do not create manual A records for the standard Key Vault path.
- The Key Vault implementation must set public network access to disabled only after the private endpoint and DNS zone-group path are verified.
- The contract accepts IDs and never accepts secret values, access tokens, or Key Vault secret contents.

## Key Vault values for Phase 4

```hcl
subnet_id                      = module.vnet.private_endpoint_subnet_id
private_connection_resource_id = module.key_vault.id
subresource_names              = ["vault"]
private_dns_zone_ids           = [module.vnet.key_vault_private_dns_zone_id]
is_manual_connection           = false
```

## DNS ownership boundary

The first release creates `privatelink.vaultcore.azure.net` in the same resource group as the VNet and links it only to that VNet. A hub-and-spoke or centrally managed DNS topology may require a different ownership model; that is a deliberate future design decision, not an implicit override of central DNS governance.
