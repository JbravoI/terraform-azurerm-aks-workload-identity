variable "name_prefix" {
  description = "Prefix used for Azure resource names. Use lowercase letters, numbers, and hyphens only."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.name_prefix)) && length(var.name_prefix) <= 50
    error_message = "name_prefix must be 1-50 characters, start and end with a lowercase letter or number, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "resource_group_name" {
  description = "Name of the existing Azure resource group in which the virtual network is created."
  type        = string
  nullable    = false
}

variable "location" {
  description = "Azure region for the virtual network. This must match the existing resource group location."
  type        = string
  nullable    = false
}

variable "vnet_address_space" {
  description = "IPv4 CIDR ranges assigned to the virtual network. Subnets will be added as separate resources in the next increment."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.vnet_address_space) > 0 && alltrue([for cidr in var.vnet_address_space : can(cidrnetmask(cidr))])
    error_message = "vnet_address_space must contain one or more valid IPv4 CIDR blocks."
  }
}

variable "aks_subnet_address_prefixes" {
  description = "IPv4 CIDR ranges for the dedicated AKS node subnet. These ranges must be contained by vnet_address_space and not overlap another subnet or AKS service/pod ranges."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.aks_subnet_address_prefixes) > 0 && alltrue([for cidr in var.aks_subnet_address_prefixes : can(cidrnetmask(cidr))])
    error_message = "aks_subnet_address_prefixes must contain one or more valid IPv4 CIDR blocks."
  }
}

variable "private_endpoint_subnet_address_prefixes" {
  description = "IPv4 CIDR ranges for the dedicated private-endpoint subnet. These ranges must be contained by vnet_address_space and not overlap another subnet or AKS service/pod ranges."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.private_endpoint_subnet_address_prefixes) > 0 && alltrue([for cidr in var.private_endpoint_subnet_address_prefixes : can(cidrnetmask(cidr))])
    error_message = "private_endpoint_subnet_address_prefixes must contain one or more valid IPv4 CIDR blocks."
  }
}

variable "key_vault_name" {
  description = "Globally unique name for the Azure Key Vault. It must be 3-24 lowercase characters, start with a letter, end with a letter or number, and contain no consecutive hyphens."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,22}[a-z0-9]$", var.key_vault_name)) && !strcontains(var.key_vault_name, "--")
    error_message = "key_vault_name must be 3-24 lowercase characters, start with a letter, end with a letter or number, and contain no consecutive hyphens."
  }
}

variable "key_vault_soft_delete_retention_days" {
  description = "Number of days that deleted Key Vault resources remain recoverable. This value is immutable after vault creation."
  type        = number
  default     = 90
  nullable    = false

  validation {
    condition     = var.key_vault_soft_delete_retention_days >= 7 && var.key_vault_soft_delete_retention_days <= 90
    error_message = "key_vault_soft_delete_retention_days must be between 7 and 90."
  }
}

variable "is_manual_private_endpoint_connection" {
  description = "Whether the Key Vault private endpoint requires approval by a separately managed target-resource owner."
  type        = bool
  default     = false
  nullable    = false
}

variable "aks_name" {
  description = "Name of the AKS cluster."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$", var.aks_name)) && length(var.aks_name) >= 3
    error_message = "aks_name must be 3-63 characters, start and end with a lowercase letter or number, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the AKS cluster."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.aks_dns_prefix)) && length(var.aks_dns_prefix) <= 54
    error_message = "aks_dns_prefix must contain only lowercase letters, numbers, and hyphens and be 54 characters or fewer."
  }
}

variable "aks_kubernetes_version" {
  description = "AKS Kubernetes version. Use a version currently supported in the selected Azure region."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+(\\.[0-9]+)?$", var.aks_kubernetes_version))
    error_message = "aks_kubernetes_version must be a Kubernetes version such as 1.36 or 1.36.2."
  }
}

variable "aks_admin_group_object_ids" {
  description = "Microsoft Entra group object IDs granted Azure RBAC administrator access to the AKS cluster."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.aks_admin_group_object_ids) > 0
    error_message = "aks_admin_group_object_ids must contain at least one approved Microsoft Entra administrator group object ID."
  }
}

variable "aks_pod_cidr" {
  description = "Non-overlapping IPv4 CIDR used by Azure CNI Overlay for pod addresses."
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrnetmask(var.aks_pod_cidr))
    error_message = "aks_pod_cidr must be a valid IPv4 CIDR block."
  }
}

variable "aks_service_cidr" {
  description = "Non-overlapping IPv4 CIDR used by Kubernetes services. It must be smaller than /12."
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrnetmask(var.aks_service_cidr))
    error_message = "aks_service_cidr must be a valid IPv4 CIDR block."
  }
}

variable "aks_dns_service_ip" {
  description = "Kubernetes DNS service IP. It must be inside aks_service_cidr and not the first address; verify this before apply."
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrhost("${var.aks_dns_service_ip}/32", 0))
    error_message = "aks_dns_service_ip must be a valid IPv4 address."
  }
}

variable "aks_node_vm_size" {
  description = "Azure VM size for the AKS system node pool."
  type        = string
  default     = "Standard_D2s_v5"
  nullable    = false
}

variable "aks_node_min_count" {
  description = "Minimum autoscaling node count for the AKS system node pool."
  type        = number
  default     = 1
  nullable    = false
}

variable "aks_node_max_count" {
  description = "Maximum autoscaling node count for the AKS system node pool."
  type        = number
  default     = 3
  nullable    = false

  validation {
    condition     = var.aks_node_max_count >= var.aks_node_min_count
    error_message = "aks_node_max_count must be greater than or equal to aks_node_min_count."
  }
}

variable "aks_node_max_pods" {
  description = "Maximum number of pods scheduled on each system node."
  type        = number
  default     = 110
  nullable    = false

  validation {
    condition     = var.aks_node_max_pods >= 1 && var.aks_node_max_pods <= 250
    error_message = "aks_node_max_pods must be between 1 and 250."
  }
}

variable "aks_log_analytics_workspace_id" {
  description = "Optional Log Analytics workspace resource ID. When supplied, AKS monitoring is enabled."
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "Additional tags applied to resources managed by this configuration."
  type        = map(string)
  default     = {}
}
