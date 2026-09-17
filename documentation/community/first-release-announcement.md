# First-release communication kit

Use these drafts only after the clean Azure verification run, release review,
and `v0.1.0` GitHub release are complete. Replace the bracketed link with the
specific GitHub release URL and adjust the wording to match the verified scope.

## LinkedIn post

> I have released an open-source Terraform reference implementation for AKS
> Workload Identity with least-privilege Azure Key Vault access.
>
> The project demonstrates how a Kubernetes workload can use a short-lived
> Microsoft Entra federated identity instead of storing an Azure client secret.
> It includes Terraform modules, CI quality gates, an architecture diagram,
> threat model, operations runbooks, and a verification example that does not
> print secret plaintext.
>
> It is intentionally a focused reference implementation rather than a full
> landing zone. I welcome practical feedback from Azure, Terraform, and
> Kubernetes practitioners: [release link]

Suggested tags: `#Azure #AKS #Terraform #Kubernetes #WorkloadIdentity #OpenSource`

## GitHub Discussion announcement

Title: `v0.1.0: secure AKS Workload Identity reference implementation`

> Version `v0.1.0` is now available: [release link]. This release provides a
> secure reference path for a private AKS workload to access Azure Key Vault
> through Microsoft Entra Workload Identity and Azure RBAC, without a stored
> client secret.
>
> Please use this discussion for non-sensitive questions, usability feedback,
> and ideas for the next focused improvement. Report vulnerabilities privately
> using the repository security policy.

## 10-minute community talk

**Title:** *Removing client secrets from AKS workloads with Terraform and
Workload Identity*

1. **Problem (1 minute):** Explain why stored client secrets in manifests,
   CI/CD, and applications create risk.
2. **Trust chain (2 minutes):** Walk through pod, Kubernetes service account,
   OIDC issuer, federated identity credential, managed identity, and Key Vault.
3. **Implementation (3 minutes):** Show the repository architecture diagram,
   Terraform interface, and least-privilege Key Vault role.
4. **Verification (2 minutes):** Demonstrate the redacted verification job;
   show the secret identifier, not secret plaintext.
5. **Boundaries and invitation (2 minutes):** State the limitations, show the
   issue/discussion routes, and invite feedback or contributions.

## Maintainer profile checklist

Before publishing the announcement, ensure the public GitHub profile for
`@JbravoI` has a recognisable avatar, a concise bio mentioning AKS/Terraform
and this project, a link to the repository, and an email/contact method only if
you are comfortable publishing it. Use the same public name and avatar on any
LinkedIn or writing profile you choose to use.

