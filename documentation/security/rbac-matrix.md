# RBAC Matrix

**Status:** Phase 6 baseline. Review this matrix with every identity, role, or scope change.

| Principal | Role | Scope | Purpose | Review/removal condition |
|---|---|---|---|---|
| Terraform provisioning identity | Environment-supplied | Resource group, AKS, Key Vault, identity, and role-assignment scopes as approved | Creates infrastructure. The module does not grant this role. | Remove privileged deployment access when the delivery path changes. |
| AKS control-plane UAI | Network Contributor | AKS node subnet | Lets AKS join/manage required subnet networking. | Remove only after the cluster is retired. |
| AKS control-plane UAI | Managed Identity Operator | Dedicated kubelet UAI resource | Lets AKS assign the kubelet identity to nodes. | Remove only after the cluster is retired or kubelet identity changes. |
| AKS kubelet UAI | None from this module | — | Reserved for node-level integrations. | Assign a narrowly scoped role only when a specific integration requires it. |
| Workload UAI | Key Vault Secrets User | Project Key Vault | Read secret contents through workload identity. | Remove when the workload/service account is decommissioned. |
| Entra AKS administrator group | Azure RBAC for Kubernetes | AKS cluster | Cluster administration without local accounts. | Review membership on the organisation’s access-review cadence. |
| CI/CD OIDC identity | Deferred | Environment-specific plan/apply scopes | Planned Phase 8 delivery identity. | Must not use an Azure client secret. |
| Break-glass administrator | Environment-controlled, time-bound | Approved Key Vault/AKS scopes | Recovery or exceptional incident response. | Remove immediately after the approved event. |

## Scope rules

- Role assignments must target the smallest practical resource scope.
- The workload UAI must never receive Owner, Contributor, Key Vault Administrator, or a role-assignment-management role.
- The federated credential must represent exactly one Kubernetes namespace and one service account.
- Changes to this matrix require a corresponding threat-model review and, when durable, an ADR.
