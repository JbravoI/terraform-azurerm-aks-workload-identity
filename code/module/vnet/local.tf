locals {
  vnet_name                    = "${var.name_prefix}-vnet"
  aks_subnet_name              = "${var.name_prefix}-aks-snet"
  private_endpoint_subnet_name = "${var.name_prefix}-pep-snet"
}
