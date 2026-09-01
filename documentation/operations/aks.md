# AKS Operations

## Preconditions for deployment

1. An approved Entra administrator group object ID is supplied in `aks_admin_group_object_ids`.
2. The deployment identity can create AKS, user-assigned identities, and role assignments.
3. The target network owner has approved the VNet, node-subnet, pod, service, and connected-network CIDRs.
4. A private management path can resolve and reach the private AKS API endpoint after deployment.
5. The requested Kubernetes version is currently supported in the selected Azure region.

## Deployment checks

After applying, verify:

```powershell
az aks show --resource-group <resource-group> --name <aks-name> --query "{private:apiServerAccessProfile.enablePrivateCluster,oidc:oidcIssuerProfile.issuerURL,workloadIdentity:securityProfile.workloadIdentity.enabled}" -o json
```

Expected conditions:

- Private cluster is enabled.
- An OIDC issuer URL is returned.
- Workload identity is enabled.

Use an approved private-network management host to acquire cluster credentials. Do not enable local accounts or public API access to work around connectivity issues.

## Upgrade operations

- The cluster uses the AKS patch upgrade channel and NodeImage OS upgrade channel.
- Review supported versions and node-image release notes before a planned upgrade.
- Validate application disruption budgets, node-pool surge capacity, and subnet capacity before upgrades.
- Test upgrades in a disposable or non-production environment before regulated/production environments.

## Monitoring and logs

Set `aks_log_analytics_workspace_id` only when an approved Log Analytics workspace is available. When omitted, the module does not create monitoring resources or send AKS logs to a workspace. Phase 8 will define CI evidence and later work will add dashboards, alerts, and runbooks.

## Incident and access response

| Event | Immediate action |
|---|---|
| Entra administrator access issue | Confirm group membership, Azure RBAC assignment, token refresh, and private DNS/connectivity. |
| Cluster cannot scale/upgrade | Inspect control-plane identity Network Contributor assignment and AKS subnet capacity. |
| Node image/integration identity failure | Inspect the control-plane Managed Identity Operator assignment over the kubelet identity. |
| Workload token issue | Preserve evidence and continue with the Phase 6 workload-identity runbook; do not introduce a client secret. |

## Recovery boundary

The module does not back up Kubernetes workloads or cluster state. Workload deployment, backup, GitOps, and application recovery are outside this phase. Destroying AKS removes the managed cluster; confirm retained networking, identities, Key Vault recovery controls, and workload dependencies before any destruction operation.
