# Key Vault Architecture and Recovery

**Phase:** 4 — Key Vault baseline and private endpoint  
**Status:** Implemented; no Key Vault secrets, keys, or certificates are managed by this project.

## Topology

```text
Terraform control plane
  └── Azure Resource Manager creates Key Vault and Private Endpoint

AKS workload path (Phase 6 onward)
  └── Linked VNet → private-endpoint subnet → Key Vault private endpoint
      └── privatelink.vaultcore.azure.net → private IP
```

The Key Vault uses Azure RBAC for data-plane authorisation. Legacy Key Vault access policies are not configured. Public data-plane access is disabled, the network ACL default is deny, and the Key Vault private endpoint uses the dedicated private-endpoint subnet plus the private DNS zone created in Phase 3.

## Resource settings

| Setting | Value | Rationale |
|---|---|---|
| SKU | Standard | Sufficient for the secret-retrieval workload-identity reference path. |
| Data-plane authorisation | Azure RBAC enabled | Centralises access decisions in Azure role assignments. |
| Public network access | Disabled | Prevents internet data-plane access. |
| Network ACL | Default deny; no trusted-service bypass | Defence in depth for the private-only pattern. |
| Soft-delete retention | 90 days by default; configurable 7–90 at creation | Enables recovery after accidental deletion. |
| Purge protection | Enabled | Prevents permanent deletion during retention. |
| Private endpoint subresource | `vault` | Azure Key Vault Private Link data-plane endpoint. |

## Naming and uniqueness

`key_vault_name` is explicitly supplied rather than derived from `name_prefix` because Key Vault names are globally unique and have stricter rules. It must be 3–24 lowercase characters, start with a letter, end with a letter or number, and contain no consecutive hyphens. A name held by a soft-deleted vault cannot be reused until the retention period ends.

## Recovery and destruction

- Soft delete and purge protection are intentionally irreversible safeguards. A destroy operation soft-deletes the vault; Azure retains it for the configured period.
- The same Key Vault name cannot be reused while it remains soft-deleted.
- Do not use provider options that automatically purge soft-deleted Key Vaults in this project.
- Recover or purge requires appropriately elevated Azure permissions and an approved operational procedure.
- Before any intentional destruction, remove dependent workloads, revoke access as appropriate, and confirm retention and cost implications.

## Private connectivity verification

After apply, test from an approved host or workload in the linked VNet:

```text
nslookup <key-vault-name>.vault.azure.net
```

The result must follow the private DNS path and return the private endpoint address. A public workstation is not a valid proof of the private workload path.
