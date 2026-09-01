# Security Policy

## Reporting a vulnerability

Do not open a public issue for a suspected vulnerability, exposed credential, insecure default, or bypass of the workload-identity boundary. Report it privately to the repository owner with:

- A concise description and affected files/resources.
- Reproduction steps that contain no secret values.
- Potential impact and suggested mitigation, if known.

The repository owner should acknowledge the report, assess containment, rotate/revoke affected identities or credentials where applicable, and publish a remediation notice after users can safely act.

## Supported security posture

This project is pre-release. Security-relevant changes must preserve private Key Vault access, Azure RBAC, purge protection, exact federated identity subjects, no client secrets, and least-privilege role assignments.

## Out of scope

Deployment-specific Azure permissions, organisation DNS/egress designs, and application secret values are environment-owned. Report unsafe defaults or documentation that could encourage insecure deployment, even when the final environment configuration remains the adopter’s responsibility.
