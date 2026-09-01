# Terraform AKS Workload Identity

A Terraform reference implementation for a secure Azure Kubernetes Service (AKS) workload-identity pattern. It provisions and configures the Azure identity relationship that lets a Kubernetes workload access Azure Key Vault without storing a long-lived Azure client secret in the application, Kubernetes manifests, or CI/CD secrets.

## Project status

**Pre-implementation.** This repository is being established as the delivery workspace. The design and documentation baseline are in place; Terraform resources, examples, CI, and release automation will be added incrementally.

## What this project will demonstrate

- A user-assigned managed identity for an AKS workload.
- A Microsoft Entra federated identity credential bound to one Kubernetes namespace and service account.
- Least-privilege Azure Key Vault data-plane access through Azure RBAC.
- A minimal workload example that authenticates through AKS Workload Identity.
- Terraform validation, linting, security scanning, and tests as delivery quality gates.
- Clear architecture, threat-model, RBAC, deployment, verification, rollback, and cleanup documentation.

## Target flow

```text
Kubernetes workload
  → Kubernetes service account
  → AKS OIDC issuer / projected service-account token
  → Microsoft Entra federated identity credential
  → User-assigned managed identity
  → Azure Key Vault (least-privilege RBAC)
```

The workload obtains short-lived tokens through workload identity. It does not use an Azure client secret to retrieve the Key Vault secret.

## Scope for the first release

The first release intentionally stays narrow:

- One existing AKS cluster integration path.
- One namespace and service account.
- One managed identity and federated credential.
- One Key Vault role assignment at the narrowest practical scope.
- One minimal, reproducible example workload.

Cluster provisioning, multi-tenancy, GitOps, ingress, observability bundles, and general platform onboarding are outside the initial scope. They may be considered only after the secure base path is documented, tested, and released.

## Planned repository layout

```text
module/                       Terraform module source
examples/basic-key-vault-access/
documentation/               Architecture, security, operations, ADRs, and release docs
.github/workflows/           CI validation and release workflows
```

## Security principles

- No plaintext secrets in Terraform variables, state, plans, manifests, screenshots, logs, or commits.
- Least-privilege Azure RBAC with documented principal, scope, purpose, and review condition.
- Short-lived, federated identity for runtime workloads and CI/CD where supported.
- Separate provisioning and runtime identities.
- A disposable personal Azure subscription for initial verification; never include employer or customer details.

## Planned quality gates

Pull requests will progressively adopt the following checks:

1. `terraform fmt -check`
2. `terraform init -backend=false`
3. `terraform validate`
4. TFLint and an IaC security scan
5. `terraform test` or equivalent focused tests
6. Terraform plan and policy review before privileged apply

## Documentation

The project documentation strategy is tracked outside this repository during the initial planning stage. It defines the expected README, architecture and identity-flow diagrams, threat model, RBAC matrix, operations guide, ADRs, test guidance, and release process. The delivery documentation will be maintained under `documentation/` as implementation begins.

## Contributing

Contributing guidance, supported versions, security reporting, and release procedures will be introduced with the first implementation milestone. Until then, proposed design decisions should be recorded with their security and operational trade-offs before Terraform resources are added.

## License

License selection is pending before the first public release.
