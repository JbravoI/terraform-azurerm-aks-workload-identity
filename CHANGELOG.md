# Changelog

All notable changes to this project are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- Terraform modules for VNet, isolated AKS/private-endpoint subnets, Key Vault private connectivity, AKS, and workload identity.
- Private Key Vault DNS, RBAC authorisation, soft delete, purge protection, and a Key Vault private endpoint.
- Private AKS with Azure CNI Overlay, Entra Kubernetes RBAC, OIDC issuer, and Microsoft Entra Workload Identity.
- A federated workload identity limited to one Kubernetes service account and Key Vault Secrets User access.
- A PowerShell-based private-cluster verification example that does not print secret plaintext.
- Terraform mock-provider tests, pull-request quality gates, and an OIDC-ready review-plan workflow.

## Release rules

- `v0.y.z` releases may change module interfaces while the reference pattern matures.
- `v1.0.0` requires all documented Phase 9 exit criteria, a licence, a clean external example run, and a reviewed release note.
- Breaking changes increment the major version; backwards-compatible features increment the minor version; fixes increment the patch version.
