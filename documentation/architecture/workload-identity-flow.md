# Workload Identity Flow

**Phase:** 6 — Federated workload identity and Key Vault RBAC  
**Status:** Terraform implementation complete; the Kubernetes service account and workload manifest are added in Phase 7.

## Trust relationship

```text
AKS OIDC issuer
  │ issues projected service-account token
  ▼
Pod using service account
  system:serviceaccount:<namespace>:<service-account>
  │ token exchange, audience: api://AzureADTokenExchange
  ▼
Federated credential on workload user-assigned managed identity
  │ Microsoft Entra token
  ▼
Workload managed identity
  │ Key Vault Secrets User at Key Vault scope
  ▼
Private Key Vault endpoint
```

## Terraform resources

The AKS module creates:

1. A dedicated user-assigned managed identity named `<aks-name>-wi-mi`.
2. A federated identity credential named `<aks-name>-kv-fic`.
3. A `Key Vault Secrets User` role assignment at the project Key Vault scope.

The federated credential is constrained to all three values below:

| Property | Value |
|---|---|
| Issuer | The deployed AKS cluster `oidc_issuer_url`. |
| Audience | `api://AzureADTokenExchange`. |
| Subject | `system:serviceaccount:<workload_namespace>:<workload_service_account>`. |

A token that differs in issuer, audience, namespace, or service-account name is not trusted by this credential.

## Required Kubernetes metadata

Phase 7 must create the service account using the Terraform output `workload_identity_client_id` and create a pod/deployment with the workload-identity label:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: keyvault-reader
  namespace: workload-identity
  annotations:
    azure.workload.identity/client-id: "<workload_identity_client_id>"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: keyvault-reader
  namespace: workload-identity
spec:
  template:
    metadata:
      labels:
        azure.workload.identity/use: "true"
    spec:
      serviceAccountName: keyvault-reader
```

Do not place a client secret, tenant secret, service-principal secret, or Key Vault secret value in the manifest. The service-account annotation uses a managed identity client ID, which is an identifier rather than a secret.

## Key Vault access boundary

The built-in `Key Vault Secrets User` role permits reading secret contents, but does not permit Key Vault infrastructure changes, RBAC management, or key/certificate operations. It is scoped to the project Key Vault. Secret-name-level restriction is not implemented in this baseline; if required, assess Azure ABAC support and organisational policy before expanding the design.
