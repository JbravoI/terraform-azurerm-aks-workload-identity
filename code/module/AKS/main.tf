resource "azurerm_user_assigned_identity" "control_plane" {
  name                = "${var.name}-cp-mi"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_user_assigned_identity" "kubelet" {
  name                = "${var.name}-kubelet-mi"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# This identity is for one application workload, not AKS control-plane or
# kubelet operations. Its federation is limited to one service-account subject.
resource "azurerm_user_assigned_identity" "workload" {
  name                = "${var.name}-wi-mi"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# The control-plane identity must be able to join and manage NIC/IP resources
# in the AKS node subnet before the cluster is created.
resource "azurerm_role_assignment" "control_plane_network_contributor" {
  scope                = var.aks_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.control_plane.principal_id
}

# AKS uses this permission to assign the dedicated kubelet identity to nodes.
resource "azurerm_role_assignment" "control_plane_kubelet_identity_operator" {
  scope                = azurerm_user_assigned_identity.kubelet.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.control_plane.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                                = var.name
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  dns_prefix                          = var.dns_prefix
  kubernetes_version                  = var.kubernetes_version
  sku_tier                            = "Standard"
  private_cluster_enabled             = true
  private_dns_zone_id                 = "System"
  private_cluster_public_fqdn_enabled = false
  local_account_disabled              = true
  role_based_access_control_enabled   = true
  oidc_issuer_enabled                 = true
  workload_identity_enabled           = true
  automatic_upgrade_channel           = "patch"
  node_os_upgrade_channel             = "NodeImage"
  tags                                = var.tags

  default_node_pool {
    name                 = "system"
    vm_size              = var.node_vm_size
    vnet_subnet_id       = var.aks_subnet_id
    auto_scaling_enabled = true
    min_count            = var.node_min_count
    max_count            = var.node_max_count
    max_pods             = var.node_max_pods
    os_sku               = "AzureLinux"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.control_plane.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.kubelet.id
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    tenant_id              = var.tenant_id
    admin_group_object_ids = var.admin_group_object_ids
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    pod_cidr            = var.pod_cidr
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
    outbound_type       = "loadBalancer"
    load_balancer_sku   = "standard"
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id == null ? [] : [var.log_analytics_workspace_id]

    content {
      log_analytics_workspace_id = oms_agent.value
    }
  }

  depends_on = [
    azurerm_role_assignment.control_plane_network_contributor,
    azurerm_role_assignment.control_plane_kubelet_identity_operator,
  ]
}

resource "azurerm_federated_identity_credential" "workload" {
  name                = "${var.name}-kv-fic"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.workload.id
  subject             = "system:serviceaccount:${var.workload_namespace}:${var.workload_service_account}"
}

# This grants secret read content only. It does not allow infrastructure
# changes, RBAC management, or Key Vault key/certificate operations.
resource "azurerm_role_assignment" "workload_key_vault_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.workload.principal_id
}
