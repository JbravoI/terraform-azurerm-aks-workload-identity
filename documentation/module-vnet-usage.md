# VNet Module Usage

## Preconditions

- An Azure resource group already exists in the selected region.
- The proposed VNet CIDR has been checked against AKS service/pod ranges and all connected networks.
- Azure authentication has permission to create a VNet in the supplied resource group.

## Configure

From `code/`, create a local variable file from the example:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

Set values appropriate for the target environment:

```hcl
name_prefix         = "example-akswi"
resource_group_name = "rg-example-akswi-dev"
location            = "uksouth"
vnet_address_space  = ["10.40.0.0/16"]

tags = {
  environment = "dev"
  owner       = "platform-engineering"
}
```

Run the standard Terraform flow:

```powershell
terraform init -backend=false
terraform validate
terraform plan
```

`terraform.tfvars` is intentionally ignored by Git. Keep it free of secrets even though it is not committed.

## Outputs

| Output | Use |
|---|---|
| `vnet_id` | Input for VNet links and other Azure resources. |
| `vnet_name` | Human-readable identifier and operational reference. |
| `vnet_address_space` | Source of truth for subnet planning and CIDR review. |

## Constraints

- Do not add an inline `subnet` block to the VNet resource.
- Do not use overlapping CIDRs.
- Do not pass credentials, secrets, tokens, or subscription details through variable files.
- Private endpoint and AKS subnets will be added in Phase 2.
