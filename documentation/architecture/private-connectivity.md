# Private Connectivity and DNS

**Phase:** 3 — Private DNS and private endpoint foundation  
**Status:** Implemented for Key Vault DNS; private endpoint creation is deferred to Phase 4.

## Implemented topology

```text
<name_prefix>-vnet
├── <name_prefix>-pep-snet
│   └── Reserved for Azure Private Endpoints
└── Private DNS zone: privatelink.vaultcore.azure.net
    └── VNet link: <name_prefix>-kv-dns-link
        └── Auto-registration: disabled
```

Azure Key Vault private endpoints require the exact private DNS zone `privatelink.vaultcore.azure.net`. The VNet link lets workloads in this VNet resolve a Key Vault private endpoint through the normal vault hostname once a Key Vault private endpoint and DNS zone group are added in Phase 4.

## Resolution expectations

| Client location | Expected result after Phase 4 |
|---|---|
| Pod or node using the linked VNet's DNS path | `<vault-name>.vault.azure.net` resolves to the private endpoint IP. |
| Public internet or an unlinked VNet | Resolves through public DNS; access must be denied after Key Vault public network access is disabled. |
| On-premises network | Requires approved conditional forwarding or equivalent DNS integration; this project does not configure it automatically. |

## Verification after Phase 4

Run resolution checks from inside the linked VNet, not from a public workstation alone:

```text
nslookup <vault-name>.vault.azure.net
nslookup <vault-name>.privatelink.vaultcore.azure.net
```

Both lookups must return the private endpoint address for the supported workload path. The test must not print secret data.

## Deliberately deferred

- `azurerm_private_endpoint` for Key Vault.
- `private_dns_zone_group` associated with that endpoint.
- Key Vault public-network disablement.
- Hub DNS, private DNS resolver, custom DNS servers, and on-premises conditional forwarding.

See [Private Endpoint Contract](../private-endpoint-contract.md) for the Phase 4 module interface.
