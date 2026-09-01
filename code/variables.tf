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

variable "tags" {
  description = "Additional tags applied to resources managed by this configuration."
  type        = map(string)
  default     = {}
}
