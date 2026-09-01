locals {
  tags = merge(
    {
      managed_by = "terraform"
      project    = "aks-workload-identity"
    },
    var.tags,
  )
}
