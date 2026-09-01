output "vnet_id" {
  description = "Resource ID of the virtual network created by this configuration."
  value       = module.vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network created by this configuration."
  value       = module.vnet.name
}

output "vnet_address_space" {
  description = "Address spaces assigned to the virtual network."
  value       = module.vnet.address_space
}

output "aks_subnet_id" {
  description = "Resource ID of the dedicated AKS node subnet."
  value       = module.vnet.aks_subnet_id
}

output "aks_subnet_name" {
  description = "Name of the dedicated AKS node subnet."
  value       = module.vnet.aks_subnet_name
}

output "aks_subnet_address_prefixes" {
  description = "Address prefixes assigned to the dedicated AKS node subnet."
  value       = module.vnet.aks_subnet_address_prefixes
}

output "private_endpoint_subnet_id" {
  description = "Resource ID of the dedicated private-endpoint subnet."
  value       = module.vnet.private_endpoint_subnet_id
}

output "private_endpoint_subnet_name" {
  description = "Name of the dedicated private-endpoint subnet."
  value       = module.vnet.private_endpoint_subnet_name
}

output "private_endpoint_subnet_address_prefixes" {
  description = "Address prefixes assigned to the dedicated private-endpoint subnet."
  value       = module.vnet.private_endpoint_subnet_address_prefixes
}

output "key_vault_private_dns_zone_id" {
  description = "Resource ID of the Azure Key Vault private DNS zone."
  value       = module.vnet.key_vault_private_dns_zone_id
}

output "key_vault_private_dns_zone_name" {
  description = "Name of the Azure Key Vault private DNS zone."
  value       = module.vnet.key_vault_private_dns_zone_name
}

output "key_vault_private_dns_zone_vnet_link_id" {
  description = "Resource ID of the Azure Key Vault private DNS zone VNet link."
  value       = module.vnet.key_vault_private_dns_zone_vnet_link_id
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault."
  value       = module.key_vault.id
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "Data-plane URI of the Key Vault. Access is private-only."
  value       = module.key_vault.uri
}

output "key_vault_private_endpoint_id" {
  description = "Resource ID of the Key Vault private endpoint."
  value       = module.key_vault.private_endpoint_id
}

output "aks_id" {
  description = "Resource ID of the AKS cluster."
  value       = module.aks.id
}

output "aks_name" {
  description = "Name of the AKS cluster."
  value       = module.aks.name
}

output "aks_oidc_issuer_url" {
  description = "OIDC issuer URL used to create federated workload-identity credentials."
  value       = module.aks.oidc_issuer_url
}

output "aks_control_plane_identity_id" {
  description = "Resource ID of the AKS control-plane user-assigned managed identity."
  value       = module.aks.control_plane_identity_id
}

output "aks_kubelet_identity_id" {
  description = "Resource ID of the dedicated kubelet user-assigned managed identity."
  value       = module.aks.kubelet_identity_id
}

output "aks_kubelet_identity_client_id" {
  description = "Client ID of the dedicated kubelet user-assigned managed identity."
  value       = module.aks.kubelet_identity_client_id
}

output "workload_identity_id" {
  description = "Resource ID of the workload user-assigned managed identity."
  value       = module.aks.workload_identity_id
}

output "workload_identity_client_id" {
  description = "Client ID to annotate on the trusted Kubernetes service account."
  value       = module.aks.workload_identity_client_id
}

output "workload_identity_principal_id" {
  description = "Principal ID of the workload user-assigned managed identity."
  value       = module.aks.workload_identity_principal_id
}

output "workload_federated_identity_credential_id" {
  description = "Resource ID of the federated workload identity credential."
  value       = module.aks.workload_federated_identity_credential_id
}

output "workload_service_account_subject" {
  description = "Exact Kubernetes service-account subject trusted by the federated credential."
  value       = module.aks.workload_service_account_subject
}
