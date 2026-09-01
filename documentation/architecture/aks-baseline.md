# AKS Cluster Baseline

**Phase:** 5 — AKS cluster baseline  
**Status:** Implemented and Terraform-validated; Azure deployment verification remains environment-specific.

## Architecture

```text
Microsoft Entra administrator groups
  └── Azure RBAC for Kubernetes authorisation

AKS control-plane user-assigned identity
  ├── Network Contributor → AKS node subnet
  └── Managed Identity Operator → dedicated kubelet identity

Private AKS cluster
  ├── System node pool → <name_prefix>-aks-snet
  ├── Azure CNI Overlay → pod CIDR
  ├── Kubernetes services → service CIDR / DNS service IP
  ├── OIDC issuer enabled
  └── Workload identity enabled
```

## Selected baseline

| Area | Setting | Rationale |
|---|---|---|
| API server | Private cluster; public FQDN disabled | Limits Kubernetes API access to the private network path. |
| Private DNS | `System` AKS private DNS zone | Keeps AKS API private-DNS lifecycle managed by AKS for this first release. |
| Kubernetes authorisation | Microsoft Entra integration with Azure RBAC; local accounts disabled | Prevents static local-admin access and centralises administrator access in approved Entra groups. |
| Network plugin | Azure CNI Overlay | Pods consume a separate pod CIDR rather than VNet subnet IPs. |
| Outbound type | Standard Load Balancer | Provides a functional baseline; it is not private egress. A production forced-tunnel/NAT design requires a future, explicit network decision. |
| Control plane identity | User-assigned managed identity | Can receive subnet permissions before AKS is created. |
| Kubelet identity | Dedicated user-assigned managed identity | Separates node/runtime infrastructure identity from the control plane. |
| Workload identity | OIDC issuer and workload identity enabled | Provides the prerequisite for Phase 6 federated identities. |
| Upgrades | AKS patch channel and NodeImage OS channel | Applies supported patch and node-image updates; version selection remains an explicit input. |
| Monitoring | Optional Log Analytics workspace input | Avoids silently creating or depending on an unspecified workspace. |

## Network plan

| Range | Input | Constraint |
|---|---|---|
| AKS node subnet | `aks_subnet_address_prefixes` | VNet-contained; sized for nodes, autoscaling, and upgrade surge. |
| Pod CIDR | `aks_pod_cidr` | Azure CNI Overlay range; must not overlap the VNet, service CIDR, or connected networks. |
| Service CIDR | `aks_service_cidr` | Must not overlap VNet, pod CIDR, or connected networks; must be smaller than `/12`. |
| DNS service IP | `aks_dns_service_ip` | Must be inside the service CIDR and must not be its first address. |

The configuration validates CIDR/IP syntax only. Azure and Terraform cannot infer all on-premises, peered-VNet, ExpressRoute, or VPN routes, so the target network owner must complete a CIDR overlap review before apply.

## Identity and permissions

| Identity | Scope | Role | Purpose |
|---|---|---|---|
| Control-plane UAI | AKS node subnet | Network Contributor | Attach and manage cluster networking resources. |
| Control-plane UAI | Kubelet UAI resource | Managed Identity Operator | Assign the dedicated kubelet identity to nodes. |
| Kubelet UAI | No role assigned by this module | — | Reserved for AKS node-level integrations. Add only narrowly scoped roles when a supported integration requires them. |
| Entra administrator group | AKS cluster | Azure RBAC for Kubernetes | Cluster administration without local accounts. |

The deployment identity must independently have permission to create managed identities, role assignments, and AKS resources. This module does not grant those permissions to its caller.

## Version policy

`aks_kubernetes_version` is a required input. Select a version supported by the target Azure region at deployment time, review the AKS release calendar before every release, and plan upgrades before end of support. The sample variable file uses `1.36` as an illustrative current baseline only; it is not a permanent pin or a substitute for regional version discovery.

## Outputs

- AKS cluster ID and name.
- OIDC issuer URL, consumed by the Phase 6 federated identity credential.
- Control-plane and kubelet identity IDs.

No kubeconfig, certificate, token, or secret is exposed as a Terraform output.
