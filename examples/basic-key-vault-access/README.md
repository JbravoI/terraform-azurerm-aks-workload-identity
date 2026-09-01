# Basic Key Vault Access Example

This example proves that an AKS workload can read a Key Vault secret through Microsoft Entra Workload Identity. It creates a namespace, the exact service account trusted by Phase 6, and a short-lived verification Job.

The Job prints only the secret identifier. It never prints the secret plaintext.

## Preconditions

- Phases 1–6 have been applied successfully.
- You run commands from a host that can reach the private AKS API and the Key Vault private DNS/network path.
- `az`, `kubelogin`, and `kubectl` are installed; `kubectl` is authenticated to the cluster with an approved Entra administrator identity.
- You have an approved, digest-pinned Azure CLI image reference. For example: `mcr.microsoft.com/azure-cli@sha256:<64-hex-character-digest>`.
- A non-production test secret exists in the project Key Vault. Do not use an employer, customer, production, or sensitive value.

> **Cost and cleanup:** AKS, private endpoints, and their supporting Azure resources can incur charges. This example creates only Kubernetes-scoped resources, but its cleanup script does not remove shared infrastructure or the test secret.

## 1. Retrieve the required non-secret values

From the repository `code/` directory after Terraform apply:

```powershell
$workloadClientId = terraform output -raw workload_identity_client_id
$keyVaultName = terraform output -raw key_vault_name
```

Set the expected cluster context from a private-network management host:

```powershell
az aks get-credentials --resource-group <resource-group> --name <aks-name> --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
```

## 2. Create a non-production verification secret

Run this only from a location authorised to use the Key Vault private endpoint. The command outputs only the secret ID.

```powershell
az keyvault secret set --vault-name $keyVaultName --name workload-identity-test --value '<non-production-value-created-locally>' --query id --output tsv
```

The secret value is supplied locally. Do not place it in a Terraform variable file, source file, terminal recording, or documentation.

## 3. Apply the example

From this directory, supply an approved immutable image digest:

```powershell
.\deploy.ps1 `
  -WorkloadIdentityClientId $workloadClientId `
  -KeyVaultName $keyVaultName `
  -SecretName workload-identity-test `
  -Image 'mcr.microsoft.com/azure-cli@sha256:<64-hex-character-digest>'
```

The script renders and applies the Kubernetes resources in memory. It does not create a manifest containing a secret.

## 4. Verify

```powershell
kubectl -n workload-identity wait --for=condition=complete job/workload-identity-verify --timeout=5m
kubectl -n workload-identity logs job/workload-identity-verify
```

Expected output includes:

```text
Workload identity verified. Secret identifier: https://<key-vault-name>.vault.azure.net/secrets/workload-identity-test/<version>
Secret plaintext was not printed.
```

Do not treat a public-host DNS result or a Job that succeeds without the `azure.workload.identity/use: "true"` label as a valid test.

## Troubleshooting

| Symptom | Check |
|---|---|
| Token-injection message in Job logs | Confirm AKS OIDC/workload identity is enabled, the Job label is present, and the service-account client-ID annotation matches `terraform output -raw workload_identity_client_id`. |
| Entra token exchange fails | Confirm the namespace/service-account names match `terraform output -raw workload_service_account_subject` exactly. |
| Key Vault `403` | Confirm the workload identity has Key Vault Secrets User at the intended vault, allow for RBAC propagation, and confirm private DNS/network path. |
| Vault hostname resolves to public IP from the Job | Verify the Phase 3 private DNS zone link and Phase 4 private DNS zone group. |
| Job cannot pull image | Use an approved reachable image digest or configure the required registry access separately; do not replace the image with an unreviewed `latest` tag. |

## 5. Cleanup

The Job automatically expires 10 minutes after completion. To delete the complete example namespace and its resources:

```powershell
.\cleanup.ps1 -Namespace workload-identity -Confirm
```

The Key Vault, private endpoint, VNet, AKS cluster, federated identity credential, and workload identity are shared infrastructure and are not removed by this cleanup script. Remove the non-production verification secret through an approved Key Vault data-plane procedure when it is no longer needed.
