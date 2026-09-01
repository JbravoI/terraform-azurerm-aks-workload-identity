[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [ValidatePattern('^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')]
  [string]$WorkloadIdentityClientId,

  [Parameter(Mandatory)]
  [ValidatePattern('^[a-z][a-z0-9-]{1,22}[a-z0-9]$')]
  [string]$KeyVaultName,

  [Parameter(Mandatory)]
  [ValidatePattern('^[0-9A-Za-z-]{1,127}$')]
  [string]$SecretName,

  [Parameter(Mandatory)]
  [ValidatePattern('^.+@sha256:[0-9a-fA-F]{64}$')]
  [string]$Image,

  [ValidatePattern('^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$')]
  [string]$Namespace = 'workload-identity',

  [ValidatePattern('^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$')]
  [string]$ServiceAccount = 'keyvault-reader'
)

$ErrorActionPreference = 'Stop'

foreach ($command in @('kubectl')) {
  if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
    throw "Required command '$command' was not found. Run this from a private-network host with kubectl configured for the AKS cluster."
  }
}

$template = @'
apiVersion: v1
kind: Namespace
metadata:
  name: __NAMESPACE__
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: __SERVICE_ACCOUNT__
  namespace: __NAMESPACE__
  annotations:
    azure.workload.identity/client-id: "__CLIENT_ID__"
---
apiVersion: batch/v1
kind: Job
metadata:
  name: workload-identity-verify
  namespace: __NAMESPACE__
  labels:
    app.kubernetes.io/name: workload-identity-verify
    app.kubernetes.io/part-of: terraform-azurerm-aks-workload-identity
spec:
  backoffLimit: 0
  ttlSecondsAfterFinished: 600
  template:
    metadata:
      labels:
        app.kubernetes.io/name: workload-identity-verify
        azure.workload.identity/use: "true"
    spec:
      restartPolicy: Never
      serviceAccountName: __SERVICE_ACCOUNT__
      automountServiceAccountToken: true
      containers:
        - name: verify-key-vault-access
          image: __IMAGE__
          imagePullPolicy: IfNotPresent
          command: ["/bin/sh", "-ec"]
          args:
            - |
              test -n "${AZURE_FEDERATED_TOKEN_FILE:-}" || { echo "Workload identity token was not injected." >&2; exit 2; }
              test -n "${AZURE_CLIENT_ID:-}" || { echo "Workload identity client ID was not injected." >&2; exit 2; }
              test -n "${AZURE_TENANT_ID:-}" || { echo "Workload identity tenant ID was not injected." >&2; exit 2; }
              az login --service-principal --username "$AZURE_CLIENT_ID" --tenant "$AZURE_TENANT_ID" --federated-token "$(cat "$AZURE_FEDERATED_TOKEN_FILE")" --output none
              secret_id="$(az keyvault secret show --vault-name "__KEY_VAULT_NAME__" --name "__SECRET_NAME__" --query id --output tsv)"
              test -n "$secret_id" || { echo "Key Vault returned no secret identifier." >&2; exit 3; }
              printf 'Workload identity verified. Secret identifier: %s\n' "$secret_id"
              echo 'Secret plaintext was not printed.'
          env:
            - name: AZURE_CORE_ONLY_SHOW_ERRORS
              value: "true"
'@

$replacements = @{
  '__NAMESPACE__'       = $Namespace
  '__SERVICE_ACCOUNT__' = $ServiceAccount
  '__CLIENT_ID__'       = $WorkloadIdentityClientId
  '__KEY_VAULT_NAME__'  = $KeyVaultName
  '__SECRET_NAME__'     = $SecretName
  '__IMAGE__'           = $Image
}

$manifest = $template
foreach ($token in $replacements.Keys) {
  $manifest = $manifest.Replace($token, $replacements[$token])
}

$manifest | kubectl apply -f -
if ($LASTEXITCODE -ne 0) {
  throw 'Kubernetes resources could not be applied.'
}

Write-Host "Job submitted. Monitor it with: kubectl -n $Namespace wait --for=condition=complete job/workload-identity-verify --timeout=5m"
Write-Host "View the redacted verification result with: kubectl -n $Namespace logs job/workload-identity-verify"
