# Contributing

## Prerequisites

- Terraform 1.14.3 or later.
- Azure CLI authentication only for an approved plan/apply; formatting, validation, and mock tests do not create Azure resources.
- TFLint for local linting.

## Local checks

Run from the repository root:

```powershell
terraform -chdir=code fmt -check -recursive
terraform -chdir=code init -backend=false -input=false
terraform -chdir=code validate
terraform -chdir=code/module/vnet init -backend=false -input=false
terraform -chdir=code/module/vnet test
terraform -chdir=code/module/Keyvault init -backend=false -input=false
terraform -chdir=code/module/Keyvault test
terraform -chdir=code/module/AKS init -backend=false -input=false
terraform -chdir=code/module/AKS test
tflint --chdir=code --recursive --config=.tflint.hcl
```

Never run an apply against a shared environment without an approved plan and environment approval.

## Change rules

- Keep one resource or tightly coupled security control per change where practical.
- Update inputs, outputs, mock tests, and relevant documentation with the same pull request.
- Update the RBAC matrix and threat model for identity, network, role, or secret-handling changes.
- Add an ADR for a durable security, architecture, cost, or operations decision.
- Do not commit state, `terraform.tfvars`, secrets, tokens, kubeconfig files, subscription/tenant IDs from real environments, or plan output containing sensitive data.

## Pull requests

The required quality workflow runs format, validation, mock-provider tests, TFLint, and Checkov. Resolve failures or request a documented, time-bound exception. Do not weaken a security control merely to satisfy CI.
