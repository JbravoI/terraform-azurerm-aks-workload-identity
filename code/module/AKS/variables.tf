variable "name" { type = string }
variable "dns_prefix" { type = string }
variable "kubernetes_version" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tenant_id" { type = string }
variable "admin_group_object_ids" { type = list(string) }
variable "aks_subnet_id" { type = string }
variable "pod_cidr" { type = string }
variable "service_cidr" { type = string }
variable "dns_service_ip" { type = string }
variable "node_vm_size" { type = string }
variable "node_min_count" { type = number }
variable "node_max_count" { type = number }
variable "node_max_pods" { type = number }

variable "log_analytics_workspace_id" {
  type     = string
  default  = null
  nullable = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
