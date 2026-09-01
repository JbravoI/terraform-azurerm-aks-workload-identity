# Incident and Rollback Runbook

## Immediate containment

| Incident | Immediate containment |
|---|---|
| Suspected workload token or pod compromise | Delete or scale down the workload, then remove the workload identity’s Key Vault role assignment and federated credential. Preserve approved audit evidence. |
| Unexpected Key Vault access | Review Key Vault diagnostic/audit sources available in the environment, remove the workload role assignment, and verify private endpoint/DNS configuration. Do not enable public access to investigate. |
| Federated subject misconfiguration | Correct the exact namespace/service-account subject, review affected Kubernetes workloads, and redeploy. Never widen the subject to `system:serviceaccount:*`. |
| AKS administrator-access issue | Validate Entra group membership, Azure RBAC for Kubernetes, private DNS, and management-path connectivity. Do not re-enable local accounts as a shortcut. |
| Unsafe Terraform plan | Do not apply. Revert the change or create a reviewed corrective change; preserve the short-lived plan artifact only under the review environment’s retention policy. |

## Access revocation order

1. Remove the Key Vault Secrets User role assignment from the workload identity.
2. Delete the federated identity credential on the workload identity.
3. Remove the Kubernetes service account annotation and delete/scale down affected workloads.
4. If the identity is no longer needed, delete the workload user-assigned managed identity.
5. Verify that secret reads fail and that no replacement long-lived credential was introduced.

## Rollback principles

- Roll back Terraform changes through a reviewed plan; do not edit Azure resources manually unless emergency procedures require it.
- A Key Vault with purge protection cannot be immediately purged. Treat delete/recovery as a controlled operation.
- VNet, private DNS, private endpoint, AKS, and Key Vault resources have dependency order. Remove workload access before removing network or Key Vault dependencies.
- Restore service through the approved private workload-identity path. Do not use client secrets, access-policy bypasses, or public firewall exceptions as a rollback mechanism.
