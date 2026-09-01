# Key Vault Access Model

**Phase:** 6 baseline. The runtime workload identity and its narrowly scoped Key Vault data-plane role are configured; the Kubernetes service account and workload manifest follow in Phase 7.

## Authorisation model

The Key Vault has `rbac_authorization_enabled = true`. It has no access-policy blocks. Azure role assignments, not Terraform variables or Key Vault access policies, determine data-plane access.

| Principal | Required scope | Purpose | Status |
|---|---|---|---|
| Terraform provisioning identity | Resource group/Key Vault management scope | Create and configure Azure resources; create future role assignments only when explicitly authorised. | Required for apply; exact role must be supplied by the environment. |
| CI/CD identity | Plan/apply scope appropriate to its environment | Run reviewed Terraform using federated Azure identity; no long-lived client secret. | Deferred to Phase 8. |
| AKS runtime workload identity | Key Vault scope; Key Vault Secrets User | Read secret contents only for the sample workload. | Configured in Phase 6. |
| Break-glass administrator | Time-bound, approved Key Vault/Azure role | Recover, investigate, or perform exceptional operations. | Environment-controlled; not assigned by this module. |

## Controls

- No Key Vault secret values are Terraform inputs, outputs, resources, logs, plans, or examples.
- The module does not assign broad Owner, Contributor, or Key Vault Administrator roles.
- The later runtime role assignment must use the narrowest Key Vault data-plane role that supports the sample operation.
- Public network access is disabled. Data-plane access must originate through the approved private network path.
- RBAC assignment changes must be recorded in the Phase 6 RBAC matrix and reviewed separately from resource creation.

## What this module does not do

- Create secrets, keys, certificates, or access-policy blocks.
- Grant data-plane permissions to the Terraform caller.
- Configure diagnostic settings, Defender, or alert rules; these are later hardening/operational additions.
- Configure custom DNS forwarding or on-premises access.
