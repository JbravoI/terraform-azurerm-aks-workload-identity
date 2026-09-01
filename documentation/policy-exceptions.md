# Policy Exceptions

An exception is a temporary, reviewed deviation from a required quality or security control. It is not a way to silence a scanner permanently.

## Required record

Create an issue or pull-request record containing the failed control, affected resource, risk, compensating control, named approver, expiry date, and removal plan. Reference that record in any narrowly scoped scanner suppression.

## Approval rules

- Security/identity/RBAC exceptions require a security reviewer.
- Network or private-access exceptions require a platform/network reviewer.
- Exceptions must be time-bound and reviewed before expiry.
- Never grant Owner, Contributor, Key Vault Administrator, public Key Vault access, or a broad federated subject as an exception for convenience.

## Closure

Remove the exception, suppression, and temporary documentation in the same change that restores the required control. Update the threat model and RBAC matrix if the exception changed actual exposure.
