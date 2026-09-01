# ADR 0001: Use an existing resource group and standalone subnet resources

**Status:** Accepted  
**Date:** 1 September 2026

## Context

This project demonstrates AKS Workload Identity and private Key Vault access. Its initial scope is not an Azure landing-zone or resource-group provisioning module. The VNet needs future AKS and private-endpoint subnets, each with different policy and lifecycle requirements.

Terraform supports inline subnet blocks within `azurerm_virtual_network` and standalone `azurerm_subnet` resources, but they must not be mixed for the same VNet.

## Decision

- Require the caller to provide an existing `resource_group_name`.
- Create the VNet in `code/module/vnet/`.
- Manage all future subnets as standalone `azurerm_subnet` resources in the VNet module.
- Do not create inline subnet blocks in `azurerm_virtual_network`.

## Consequences

### Positive

- The module stays focused on the workload-identity reference pattern.
- AKS and private endpoints can use distinct subnet ranges and controls.
- Future subnet delegation, private-endpoint network-policy settings, route tables, and NSG associations can be managed independently.
- The caller retains ownership of resource-group lifecycle and landing-zone policy.

### Trade-offs

- The caller must create and manage the resource group before applying this configuration.
- The repository will contain more resource definitions than an inline-subnet implementation.
- Existing VNet/subnet environments require import and migration planning rather than a blind apply.

## Alternatives considered

1. **Create the resource group in this module:** rejected because it expands scope and couples the reference implementation to landing-zone lifecycle.
2. **Define inline VNet subnets:** rejected because later standalone subnets would conflict and because AKS/private endpoints need separate controls.
3. **Consume an existing VNet:** deferred. A future integration mode may accept an existing VNet, but the first release creates a clear, reproducible VNet foundation.

## Review trigger

Review this decision if the project adds an existing-VNet integration mode, a landing-zone module, or a network topology requiring centrally managed subnets.
