# Network Overview

**Phase:** 1 — Virtual network foundation  
**Status:** Implemented; subnet allocation is deferred to Phase 2.

## Purpose

The virtual network is the private network boundary for the AKS workload-identity reference implementation. It will host a dedicated AKS subnet and a separate private-endpoint subnet. Key Vault private connectivity, AKS nodes, and future private endpoints must remain inside this boundary.

## Current topology

```text
Existing Azure resource group
└── Virtual network: <name_prefix>-vnet
└── Address space: var.vnet_address_space
    ├── AKS node subnet: var.aks_subnet_address_prefixes
    └── Private-endpoint subnet: var.private_endpoint_subnet_address_prefixes
```

No subnets are defined inline in the VNet. This prevents standalone `azurerm_subnet` resources from conflicting with VNet configuration and lets AKS and private endpoints receive separate policy controls. The detailed subnet design is in [Subnet Design](subnet-design.md).

## Inputs and naming

| Input | Requirement | Purpose |
|---|---|---|
| `name_prefix` | 1–50 lowercase letters, numbers, and hyphens; starts/ends alphanumeric | Creates `<name_prefix>-vnet`. |
| `resource_group_name` | Existing resource group | Keeps the module focused on networking rather than lifecycle of the resource group. |
| `location` | Same Azure region as the resource group | Azure location for the VNet. |
| `vnet_address_space` | One or more valid IPv4 CIDR blocks | Parent CIDR range for all later subnets. |
| `tags` | Optional string map | Merged with `managed_by=terraform` and `project=aks-workload-identity`. |

## Address-space allocation rule

The chosen VNet CIDR must not overlap with:

- The AKS service CIDR.
- The AKS pod CIDR when the selected network model uses a distinct pod range.
- On-premises networks, hub networks, peered VNets, VPN/ExpressRoute routes, or any other connected network.

Phase 2 will assign non-overlapping subnet ranges and document the exact allocation table. No default subnet size is prescribed here because the correct size depends on the selected AKS network model, node-pool scale, private-endpoint count, and connected-network routes.

## Module contract

The root configuration calls `./module/vnet` and exposes `vnet_id`, `vnet_name`, and `vnet_address_space`. Downstream AKS, private DNS, and private-endpoint resources will consume these outputs rather than recreate or rediscover the VNet.

## Validation

```powershell
cd code
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init -backend=false
terraform validate
terraform plan
```

Replace all example values before planning. Authentication is required for a real plan against Azure; do not commit the copied `terraform.tfvars` file.
