# ADR 0002: Create and link the Key Vault private DNS zone in the workload VNet resource group

**Status:** Accepted for the first release  
**Date:** 1 September 2026

## Context

The project needs a Key Vault private endpoint in Phase 4. Azure Key Vault requires the private DNS zone `privatelink.vaultcore.azure.net` for standard private endpoint name resolution. A private DNS zone must be linked to the workload VNet for VNet clients to resolve the private address.

## Decision

- Create `privatelink.vaultcore.azure.net` in the same existing resource group as the VNet.
- Link it to the project VNet with automatic registration disabled.
- Expose the DNS zone ID and VNet-link ID as module outputs.
- Pass the zone ID to the Phase 4 private-endpoint DNS zone group.

## Consequences

### Positive

- The first release is self-contained and has an explicit DNS dependency chain.
- The Key Vault private endpoint can use an Azure-managed DNS zone group rather than manually managed A records.
- The VNet link is visible, versioned, and reviewable with the network configuration.

### Trade-offs

- This is not a centralised hub-and-spoke DNS design.
- An environment that already owns this zone centrally must adapt the module or use a later existing-zone integration mode; duplicate zones must not be created in the same DNS ownership scope without review.

## Alternatives considered

1. **Create no zone until the Key Vault private endpoint:** rejected because the DNS dependency and ownership decision would be hidden until a later phase.
2. **Create manual private DNS records:** rejected because a zone group can manage the standard Key Vault endpoint records with less operational risk.
3. **Assume a centrally managed zone:** deferred because no central DNS topology or resource ID has been supplied for this first release.

## Review trigger

Review when deploying to a hub-and-spoke topology, using Azure Private DNS Resolver, connecting on-premises DNS, or consuming an organisation-owned private DNS zone.
