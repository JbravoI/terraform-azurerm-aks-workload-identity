locals {
  vnet_name                    = "${var.name_prefix}-vnet"
  aks_subnet_name              = "${var.name_prefix}-aks-snet"
  private_endpoint_subnet_name = "${var.name_prefix}-pep-snet"
  key_vault_private_dns_zone   = "privatelink.vaultcore.azure.net"
  key_vault_dns_link_name      = "${var.name_prefix}-kv-dns-link"
}
