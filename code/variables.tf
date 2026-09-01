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

variable "tags" {
  description = "Additional tags applied to resources managed by this configuration."
  type        = map(string)
  default     = {}
}
