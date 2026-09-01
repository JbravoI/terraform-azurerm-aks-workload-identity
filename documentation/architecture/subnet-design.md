# Subnet Design

**Phase:** 2 — AKS and private-endpoint subnet controls  
**Status:** Implemented; CIDRs must be reviewed against the target environment before apply.

## Topology

```text
<name_prefix>-vnet
├── <name_prefix>-aks-snet
│   └── AKS worker nodes and AKS-managed node-pool networking
└── <name_prefix>-pep-snet
    └── Azure Private Endpoints only (Key Vault in Phase 4)
```

## Address-plan requirements

| Allocation | Terraform input | Purpose | Controls |
|---|---|---|---|
| VNet | `vnet_address_space` | Parent private network boundary | Must contain both subnet ranges. |
| AKS node subnet | `aks_subnet_address_prefixes` | AKS worker nodes and node-pool infrastructure | Not delegated; sized for nodes, upgrade surge, internal load balancers, and selected AKS network model. |
| Private-endpoint subnet | `private_endpoint_subnet_address_prefixes` | Azure Private Endpoints only | `private_endpoint_network_policies = "Disabled"`; no workloads or AKS nodes. |
| AKS service/pod ranges | Deferred to Phase 5 | Kubernetes virtual networking | Must not overlap any VNet or connected-network range. |

The example uses `10.40.0.0/16`, `10.40.0.0/20`, and `10.40.16.0/24` only as an internally non-overlapping example. They are not approved production ranges.

## Why the subnets are separate

The AKS node subnet and private-endpoint subnet have distinct scaling, traffic, and policy requirements. Isolating private endpoints prevents accidental placement of workloads in a subnet with private-endpoint-specific network policy settings. The AKS subnet remains a standard, non-delegated subnet for the initial bring-your-own-VNet cluster model.

## Network policy decision

The private-endpoint subnet explicitly sets `private_endpoint_network_policies = "Disabled"`. This is the current supported AzureRM setting for a subnet where private-endpoint network policies are disabled. It applies only to private endpoints on that subnet; it does not replace broader NSG or route-table design. No NSG is associated in this phase because an allow-list traffic model has not yet been approved.

## Pre-apply CIDR review

Before applying, document and check all of the following:

1. VNet, AKS-subnet, and private-endpoint-subnet CIDRs do not overlap each other.
2. Subnet CIDRs are contained by the VNet address space.
3. The VNet and subnet ranges do not overlap AKS service CIDR, pod CIDR where applicable, hub/peered VNets, on-premises routes, VPN/ExpressRoute routes, or reserved organisational ranges.
4. AKS subnet capacity includes maximum node count, upgrade surge capacity, and required internal load balancers.
5. Private-endpoint subnet capacity accounts for every planned private endpoint and Azure-reserved IP addresses.

## Deliberately deferred

- Network Security Groups and NSG associations.
- Route tables and forced-tunnelling configuration.
- AKS API-server VNet integration subnet, which would be a separate delegated subnet if that AKS mode is selected.
- Private DNS zones and private endpoint resources (Phase 3 and Phase 4).
