variable "name_prefix" {
  description = "Prefix used for the virtual network name."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "Name of the existing resource group in which the virtual network is created."
  type        = string
  nullable    = false
}

variable "location" {
  description = "Azure region for the virtual network."
  type        = string
  nullable    = false
}

variable "address_space" {
  description = "IPv4 CIDR ranges assigned to the virtual network."
  type        = list(string)
  nullable    = false
}

variable "aks_subnet_address_prefixes" {
  description = "IPv4 CIDR ranges for the dedicated AKS node subnet."
  type        = list(string)
  nullable    = false
}

variable "private_endpoint_subnet_address_prefixes" {
  description = "IPv4 CIDR ranges for the dedicated private-endpoint subnet."
  type        = list(string)
  nullable    = false
}

variable "tags" {
  description = "Tags applied to the virtual network."
  type        = map(string)
  default     = {}
}
