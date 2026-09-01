variable "name" {
  description = "Globally unique name of the Azure Key Vault."
  type        = string
  nullable    = false
}

variable "location" {
  description = "Azure region for the Key Vault and private endpoint."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "Existing resource group in which the Key Vault and private endpoint are created."
  type        = string
  nullable    = false
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID for the Key Vault."
  type        = string
  nullable    = false
}

variable "private_endpoint_subnet_id" {
  description = "Resource ID of the dedicated private-endpoint subnet."
  type        = string
  nullable    = false
}

variable "private_dns_zone_ids" {
  description = "Private DNS zone IDs associated with the Key Vault private endpoint."
  type        = list(string)
  nullable    = false
}

variable "soft_delete_retention_days" {
  description = "Number of days that deleted Key Vault resources remain recoverable."
  type        = number
  nullable    = false
}

variable "is_manual_private_endpoint_connection" {
  description = "Whether the target-resource owner must manually approve the private endpoint connection."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the Key Vault and private endpoint."
  type        = map(string)
  default     = {}
}
