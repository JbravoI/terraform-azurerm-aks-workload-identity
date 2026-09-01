mock_provider "azurerm" {}

run "enforces_private_workload_identity_cluster" {
  command = plan

  variables {
    name                       = "example-akswi-aks"
    dns_prefix                 = "example-akswi"
    kubernetes_version         = "1.36"
    location                   = "uksouth"
    resource_group_name        = "rg-example-akswi-dev"
    tenant_id                  = "00000000-0000-0000-0000-000000000000"
    admin_group_object_ids     = ["00000000-0000-0000-0000-000000000000"]
    aks_subnet_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-akswi-dev/providers/Microsoft.Network/virtualNetworks/example-akswi-vnet/subnets/example-akswi-aks-snet"
    pod_cidr                   = "10.244.0.0/16"
    service_cidr               = "10.245.0.0/16"
    dns_service_ip             = "10.245.0.10"
    node_vm_size               = "Standard_D2s_v5"
    node_min_count             = 1
    node_max_count             = 3
    node_max_pods              = 110
    log_analytics_workspace_id = null
    key_vault_id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-akswi-dev/providers/Microsoft.KeyVault/vaults/exampleakswkv001"
    workload_namespace         = "workload-identity"
    workload_service_account   = "keyvault-reader"
    tags                       = { environment = "test" }
  }

  assert {
    condition     = azurerm_kubernetes_cluster.aks.private_cluster_enabled && azurerm_kubernetes_cluster.aks.oidc_issuer_enabled && azurerm_kubernetes_cluster.aks.workload_identity_enabled
    error_message = "AKS must be private and enable both OIDC issuer and workload identity."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.aks.network_profile[0].network_plugin_mode == "overlay" && azurerm_kubernetes_cluster.aks.local_account_disabled
    error_message = "AKS must use Azure CNI Overlay and disable local accounts."
  }

  assert {
    condition     = azurerm_federated_identity_credential.workload.subject == "system:serviceaccount:workload-identity:keyvault-reader" && length(azurerm_federated_identity_credential.workload.audience) == 1 && contains(azurerm_federated_identity_credential.workload.audience, "api://AzureADTokenExchange")
    error_message = "The federated credential must trust exactly the configured service account and token-exchange audience."
  }

  assert {
    condition     = azurerm_role_assignment.workload_key_vault_secrets_user.role_definition_name == "Key Vault Secrets User"
    error_message = "The workload identity must receive only the Key Vault Secrets User role."
  }
}
