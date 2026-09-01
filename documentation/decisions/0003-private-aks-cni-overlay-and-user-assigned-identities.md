# ADR 0003: Use private AKS with Azure CNI Overlay and pre-authorised user-assigned identities

**Status:** Accepted  
**Date:** 1 September 2026

## Context

The project needs an AKS cluster capable of Azure Workload Identity access to a private Key Vault. The cluster requires a secure API access model, known network ranges, a stable identity model, and an OIDC issuer for the later federated identity credential.

## Decision

- Use a private AKS cluster with the public FQDN disabled.
- Use Azure CNI Overlay, with separate, caller-supplied pod and service CIDRs.
- Use a user-assigned control-plane identity and grant it Network Contributor on the AKS node subnet before AKS creation.
- Use a separate user-assigned kubelet identity and grant the control-plane identity Managed Identity Operator over it.
- Enable OIDC issuer, Azure Workload Identity, Microsoft Entra integration, and Azure RBAC for Kubernetes.
- Disable local Kubernetes accounts and require at least one Microsoft Entra administrator group.
- Use the AKS-managed (`System`) private DNS zone for the API server in the first release.
- Use Standard Load Balancer outbound connectivity as the functional baseline; a production private-egress pattern is deferred.

## Consequences

### Positive

- The cluster is ready for Phase 6 workload identity without a long-lived application credential.
- Pre-authorised user-assigned identities avoid the custom-VNet permission timing problem of system-assigned control-plane identities.
- Overlay networking reduces VNet IP consumption by allocating pod addresses from a separate CIDR.
- Entra groups provide auditable administrator access without local accounts.

### Trade-offs

- Private-cluster management requires network-connected operator access and DNS resolution.
- The deployment identity needs privileges to create both role assignments and managed identities.
- Standard Load Balancer outbound access is not a fully private egress architecture.
- Service, pod, VNet, and connected-network ranges need external review before each deployment.

## Alternatives considered

1. **System-assigned control-plane identity:** rejected for the initial BYO-VNet pattern because its subnet permissions cannot be granted until after cluster creation.
2. **Azure CNI node-subnet mode:** rejected because it consumes VNet IPs for pods and needs larger network capacity for the reference pattern.
3. **Public AKS API endpoint:** rejected because it conflicts with the project’s private-access posture.
4. **Local Kubernetes admin accounts:** rejected because they weaken centralised, identity-based access control.

## Review trigger

Review this decision for hub-and-spoke private DNS, private/forced-tunnel egress, an API-server VNet integration subnet, Windows node pools, a different data plane, or an organisation-mandated AKS version/upgrade channel.
