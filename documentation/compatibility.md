# Compatibility and Support Boundary

## Terraform and provider support

| Component | Supported baseline | Notes |
|---|---|---|
| Terraform | `>= 1.14.3` for the current test/CI baseline | Terraform mock-provider tests are part of the quality gate. |
| AzureRM provider | `>= 4.0, < 5.0` | Root and standalone modules declare this constraint. Lock the validated version in the root `.terraform.lock.hcl`. |
| Azure CLI | Current supported release | Required only for Azure deployment and the Phase 7 example. |
| kubectl/kubelogin | Compatible with the deployed AKS version | Required from a private-network management host. |

## Azure and Kubernetes support

- `aks_kubernetes_version` is intentionally a required input. Select a Kubernetes version supported in the chosen Azure region at deployment time.
- The example `1.36` value is illustrative only; it is not a promise that the version remains available or supported.
- AKS uses Azure CNI Overlay, a private API server, OIDC issuer, Microsoft Entra Workload Identity, and Entra/Azure RBAC for Kubernetes.
- The Key Vault pattern uses Azure RBAC, `privatelink.vaultcore.azure.net`, a private endpoint, disabled public data-plane access, soft delete, and purge protection.

## Supported reference pattern

The repository supports one AKS cluster, one workload managed identity, one namespace/service-account trust subject, and one Key Vault secret-read path. It is designed as a secure reference implementation, not a full landing-zone or multi-tenant platform.

## Known limitations

- No remote Terraform backend is configured. Before applying outside a disposable environment, configure an approved Azure Storage backend with RBAC, locking, backup/recovery, and state-access logging.
- Standard Load Balancer outbound connectivity is a functional baseline, not private egress. Forced tunnelling, NAT, firewall, or hub-network integrations need their own approved design.
- The Key Vault role permits the workload identity to read secret contents throughout the configured vault. Per-secret isolation is not included.
- No GitOps controller, application backup, dashboards, alert rules, diagnostic settings, or policy engine is deployed.
- Private AKS requires a management host with private DNS and network connectivity.
- The repository does not yet provide an existing-VNet/Key-Vault integration mode or a central private-DNS-zone mode.
