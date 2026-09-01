# Testing and Quality Standard

## Required pull-request controls

| Control | Evidence | Risk mitigated |
|---|---|---|
| `terraform fmt -check` | Workflow log | Inconsistent or unreadable Terraform changes. |
| `terraform init -backend=false` and `validate` | Workflow log | Invalid provider/module configuration. |
| Terraform mock-provider tests | Test result | Regression of private networking, recovery, OIDC/workload identity, or least-privilege settings. |
| TFLint | Lint result | Terraform-language and local-module quality defects. |
| Checkov | IaC scan result | Broad static cloud/IaC misconfiguration coverage. |
| Approved review plan | Short-lived JSON plan artifact | Unreviewed infrastructure impact. |

## Policy assertions maintained in Terraform tests

- Private-endpoint network policies are disabled for the dedicated private-endpoint subnet.
- Key Vault uses Azure RBAC, purge protection, default-deny ACLs, and disabled public access.
- AKS is private and has OIDC issuer/workload identity enabled.
- The federated subject is one exact service account and uses the token-exchange audience.
- The workload identity receives Key Vault Secrets User rather than an infrastructure-management role.

## Review-plan workflow

`Approved Terraform review plan` is manually dispatched into the protected `review` environment. Configure `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, and `AZURE_SUBSCRIPTION_ID` as environment variables and configure Azure federated credentials for GitHub OIDC. Store the non-secret review configuration in the `TF_REVIEW_TFVARS` environment secret. The workflow writes it only for the run, emits `tfplan.json`, and retains that artifact for seven days.

The workflow never uses an Azure client secret. Restrict environment approval to authorised reviewers and do not use a production subscription as the review environment.
