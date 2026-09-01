[CmdletBinding(SupportsShouldProcess)]
param(
  [ValidatePattern('^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$')]
  [string]$Namespace = 'workload-identity'
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
  throw "Required command 'kubectl' was not found."
}

if ($PSCmdlet.ShouldProcess("namespace/$Namespace", 'Delete the Phase 7 example namespace and all resources it contains')) {
  kubectl delete namespace $Namespace --ignore-not-found
  if ($LASTEXITCODE -ne 0) {
    throw "Kubernetes namespace '$Namespace' could not be deleted."
  }
}
