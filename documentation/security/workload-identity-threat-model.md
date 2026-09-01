# Workload Identity Threat Model

**Scope:** The Phase 6 AKS service-account to Key Vault secret-read path.

## Assets and trust boundaries

| Asset/boundary | Protection objective |
|---|---|
| Kubernetes projected service-account token | Prevent token theft or use by an untrusted subject. |
| Federated identity credential | Limit Entra token exchange to the intended issuer, audience, namespace, and service account. |
| Workload UAI | Restrict Azure permissions to secret reads at the intended Key Vault. |
| Key Vault secret contents | Keep values out of Terraform, Kubernetes manifests, logs, and unintended workload access. |
| Private DNS/endpoint path | Prevent public data-plane access to the Key Vault. |

## Threats and controls

| Threat | Control | Residual risk / follow-up |
|---|---|---|
| A pod in another namespace attempts token exchange | Exact federated subject includes namespace and service-account name. | A compromised pod using the trusted service account can still request a token. Apply Kubernetes RBAC, Pod Security Admission, and workload hardening in later phases. |
| An issuer/audience mismatch is accepted | Credential pins the AKS OIDC issuer and `api://AzureADTokenExchange` audience. | Confirm deployed output values during Phase 7 verification. |
| Workload receives infrastructure authority | Workload UAI has only Key Vault Secrets User at Key Vault scope. | The role can read secret contents across that vault; use separate vaults or approved ABAC restrictions if per-secret isolation is required. |
| Secret leaks through Terraform | No `azurerm_key_vault_secret` resource, secret variable, or secret output is created. | Operators must avoid adding plaintext secrets to variable files, plans, logs, or documentation. |
| Secret read occurs over public network | Key Vault public access is disabled; private endpoint and DNS zone group are configured. | Validate DNS and data-plane path from inside the VNet in Phase 7. |
| Federated credential is repointed to another service account | Terraform review and exact inputs; subject is exposed as a non-secret output for review. | Phase 8 policy/CI should detect unauthorised identity/RBAC drift. |
| Role-assignment propagation delays cause deployment failures | Terraform dependencies bind to resource IDs; operations guidance requires retry/propagation awareness. | Azure RBAC propagation remains asynchronous. |

## Non-goals

This phase does not create Kubernetes resources, network policies, admission policies, secret rotation, CI/CD OIDC, or observability alerts. Those controls are addressed in later phases.
