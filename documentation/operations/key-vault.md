# Key Vault Operations

## Deployment sequence

1. Review the globally unique `key_vault_name`; confirm it is not held by a soft-deleted vault.
2. Confirm the Phase 2 private-endpoint subnet and Phase 3 private DNS zone/link are present.
3. Apply the Terraform configuration with an identity authorised to create the Key Vault and private endpoint.
4. Confirm the private endpoint connection is approved and provisioning succeeds.
5. From the linked VNet, resolve `<key-vault-name>.vault.azure.net` and confirm the private IP result.
6. Before creating a runtime secret or granting workload access, complete Phase 6 identity/RBAC controls.

## Troubleshooting boundaries

| Symptom | Check | Do not do |
|---|---|---|
| DNS resolves public IP from an in-VNet client | Private DNS zone link, zone-group association, and custom DNS forwarding path | Re-enable Key Vault public access as a shortcut. |
| Private endpoint is pending/rejected | Target-resource approval and the selected manual-connection setting | Add a public firewall exception. |
| Key Vault data-plane `403` | Azure RBAC role, scope, propagation time, and workload identity (Phase 6) | Add a broad access policy or give the workload Owner. |
| Vault name unavailable | Check for existing/soft-deleted vault with the same global name | Purge a vault without approved recovery/destruction authority. |

## Recovery and rollback

- A failed private endpoint deployment can be corrected by changing the endpoint configuration; retain the Key Vault and its recovery safeguards.
- Deleting the Key Vault triggers soft delete. With purge protection enabled, it remains recoverable but cannot be immediately purged.
- Roll back access by removing the future workload role assignment or federated credential, not by exposing the vault publicly.
