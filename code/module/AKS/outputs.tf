output "id" {
  description = "Resource ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.id
}

output "name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL used to create federated workload-identity credentials."
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "control_plane_identity_id" {
  description = "Resource ID of the AKS control-plane user-assigned managed identity."
  value       = azurerm_user_assigned_identity.control_plane.id
}

output "control_plane_principal_id" {
  description = "Principal ID of the AKS control-plane user-assigned managed identity."
  value       = azurerm_user_assigned_identity.control_plane.principal_id
}

output "kubelet_identity_id" {
  description = "Resource ID of the dedicated kubelet user-assigned managed identity."
  value       = azurerm_user_assigned_identity.kubelet.id
}

output "kubelet_identity_client_id" {
  description = "Client ID of the dedicated kubelet user-assigned managed identity."
  value       = azurerm_user_assigned_identity.kubelet.client_id
}

output "workload_identity_id" {
  description = "Resource ID of the workload user-assigned managed identity."
  value       = azurerm_user_assigned_identity.workload.id
}

output "workload_identity_client_id" {
  description = "Client ID to annotate on the trusted Kubernetes service account."
  value       = azurerm_user_assigned_identity.workload.client_id
}

output "workload_identity_principal_id" {
  description = "Principal ID of the workload user-assigned managed identity."
  value       = azurerm_user_assigned_identity.workload.principal_id
}

output "workload_federated_identity_credential_id" {
  description = "Resource ID of the federated credential binding the workload identity to the Kubernetes service account."
  value       = azurerm_federated_identity_credential.workload.id
}

output "workload_service_account_subject" {
  description = "Exact Kubernetes service-account subject trusted by the federated credential."
  value       = azurerm_federated_identity_credential.workload.subject
}
