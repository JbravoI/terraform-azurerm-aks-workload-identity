# Delivery Phases — Terraform AKS Workload Identity

**Status:** Active delivery plan  
**Scope:** A secure Terraform reference implementation for AKS Workload Identity and Azure Key Vault access.

## Delivery principles

- Build one infrastructure resource or tightly coupled control at a time; every phase must leave the configuration formatted, valid, and documented.
- Use an existing resource group for the first release. Do not create or expose long-lived secrets.
- Keep runtime workload identity, Terraform provisioning identity, and CI/CD identity separate.
- Treat documentation as part of the change: an unrecorded security or operational decision is incomplete.
- Test only in a disposable personal Azure subscription until a different environment is explicitly approved.

## Phase summary

| Phase | Outcome | Primary code area | Primary documentation |
|---|---|---|---|
| 0 | Repository baseline | Root, `code/` | README, strategy, contribution baseline |
| 1 | Network foundation | `code/module/vnet/` | Network design and address plan |
| 2 | AKS-ready subnet controls | `code/module/vnet/` | Subnet purpose and delegation decisions |
| 3 | Private DNS and private endpoint foundation | `code/module/vnet/` | Private connectivity diagram and DNS guide |
| 4 | Key Vault security baseline | `code/module/Keyvault/` | Key Vault access and recovery design |
| 5 | AKS cluster baseline | `code/module/AKS/` | Cluster architecture and operations guide |
| 6 | Workload identity binding | AKS + Key Vault modules | Identity flow, RBAC matrix, threat model |
| 7 | Runnable workload example | `examples/` | Deploy, verify, troubleshoot, cleanup guide |
| 8 | Quality, policy, and CI/CD | `.github/`, tests | Testing standard, policy evidence, contribution guide |
| 9 | Release readiness | All | Security policy, changelog, release process, v1.0.0 docs |

---

## Phase 0 — Repository and documentation baseline

**Goal:** Establish a predictable project structure and clearly state the supported problem before further infrastructure is added.

### Code

- [x] Create the root Terraform configuration in `code/`.
- [x] Configure Terraform and AzureRM provider requirements in `code/providers.tf`.
- [x] Add root-level naming/tag locals in `code/local.tf`.
- [x] Add validated root inputs in `code/variables.tf`.
- [x] Create module directories for VNet, AKS, and Key Vault.
- [x] Add `.gitignore` coverage for the externally managed project strategy.
- [x] Add `.gitignore` entries for `.terraform/`, `*.tfstate`, `*.tfstate.*`, crash logs, and local variable files; do not ignore `.terraform.lock.hcl`.

### Documentation

- [x] Add the project README with scope, target flow, and security principles.
- [x] Create the pre-project documentation strategy.
- [x] Add this phased delivery plan.
- [ ] Add `CONTRIBUTING.md`, `SECURITY.md`, and a licence decision before public release.
- [ ] Add a numbered ADR template under `documentation/decisions/`.

### Exit criteria

- The directory structure and module responsibilities are visible in the README.
- `terraform fmt -check -recursive code` passes.
- No sensitive environment files or state can be accidentally committed.

---

## Phase 1 — Virtual network foundation

**Status:** Complete for code and documentation. Target-environment CIDR overlap review is required before the first Azure apply.

**Goal:** Provide the network container for AKS, Key Vault private access, and future private endpoints.

### Code

- [x] Add the `azurerm_virtual_network` resource in `code/module/vnet/`.
- [x] Pass name prefix, location, existing resource group, address space, and tags through the root module call.
- [x] Add VNet outputs for ID, name, and address space when the next phase needs them.
- [ ] Add optional custom DNS server support only if required by the target landing zone.

### Documentation

- [x] Add `documentation/architecture/network-overview.md` with the VNet boundary and address-space allocation.
- [x] Record an ADR explaining why the first release consumes an existing resource group and uses standalone subnet resources.
- [x] Document VNet naming, tagging, location, and CIDR input rules in the module usage guidance.

### Exit criteria

- [x] The VNet can be planned from a clean configuration using supplied variables.
- [x] A documented pre-apply CIDR review requires the selected address space to avoid AKS service/pod ranges and connected networks.
- [x] No inline subnets are added to the VNet resource; all subnets remain separately managed.

---

## Phase 2 — AKS and private-endpoint subnet controls

**Status:** Complete for code and documentation. Target-environment CIDR and capacity review is required before the first Azure apply.

**Goal:** Create isolated, purpose-specific subnets without mixing AKS node traffic and private endpoints.

### Code

- [x] Add an AKS node subnet as `azurerm_subnet` in `code/module/vnet/`.
- [x] Add a dedicated private-endpoint subnet as `azurerm_subnet`.
- [x] Disable private-endpoint network policies on the private-endpoint subnet using the AzureRM provider’s current supported argument.
- [x] Add subnet outputs: IDs, names, and address prefixes.
- [ ] Add Network Security Groups and associations only after their required rules are designed and documented; avoid placeholder allow-all rules.

### Documentation

- [x] Add an address-plan table: VNet CIDR, AKS subnet, private-endpoint subnet, reserved ranges, owner, and purpose.
- [x] Document why private endpoints use a separate subnet and which policy setting is required.
- [x] Update the architecture diagram with subnet trust boundaries.

### Exit criteria

- [x] A pre-apply review requires subnet CIDRs to be contained by the VNet and not overlap.
- [x] AKS and private endpoint resources receive distinct subnet IDs.
- [x] No NSG rule is created until a documented purpose, source, destination, protocol, port, and review owner exist.

---

## Phase 3 — Private connectivity and DNS foundation

**Status:** Complete for code and documentation. Private endpoint creation and Key Vault public-network disablement remain Phase 4 work.

**Goal:** Provide the reusable building blocks needed to connect private Azure services without public network access.

### Code

- [x] Create the private DNS zone required for Key Vault: `privatelink.vaultcore.azure.net`.
- [x] Link the private DNS zone to the VNet with `azurerm_private_dns_zone_virtual_network_link`.
- [x] Define a reusable private-endpoint interface or module contract: subnet ID, target resource ID, subresource names, DNS zone IDs, and tags.
- [x] Do not create a Key Vault private endpoint until the Key Vault exists in Phase 4.

### Documentation

- [x] Add a private DNS and connectivity diagram.
- [x] Document name-resolution expectations for workload pods, nodes, and operator workstations.
- [x] Record an ADR for Azure Private DNS zone ownership and any hub-and-spoke integration boundary.

### Exit criteria

- [x] A private DNS zone is linked to the intended VNet.
- [x] The module interface does not accept or expose secrets.
- [x] DNS ownership and integration assumptions are explicit.

---

## Phase 4 — Key Vault baseline and private endpoint

**Status:** Complete for code and documentation. Runtime workload access is intentionally deferred to Phase 6.

**Goal:** Deploy a recoverable, RBAC-authorised Key Vault that is reachable through private connectivity.

### Code

- [x] Create `code/module/Keyvault/` resource definitions for `azurerm_key_vault`.
- [x] Enable Azure RBAC authorisation; do not use legacy access policies unless an ADR documents an environment constraint.
- [x] Enable soft delete and purge protection, with retention settings documented.
- [x] Disable public network access after the private endpoint path is functional.
- [x] Create the Key Vault private endpoint in the dedicated subnet.
- [x] Add the private DNS zone group association to the Key Vault private endpoint.
- [x] Export non-sensitive outputs only: Key Vault ID, name, URI, and private endpoint ID.

### Documentation

- [x] Add Key Vault architecture and recovery requirements.
- [x] Add a Key Vault access model that distinguishes provisioning, runtime workload, and break-glass administration.
- [x] Add operational steps for private DNS verification, soft-delete recovery, and safe destruction constraints.

### Exit criteria

- [x] Key Vault has no public access path in the supported deployment mode.
- [x] Private DNS is configured to resolve the vault name to its private endpoint from the VNet after deployment.
- [x] No secret values are Terraform inputs, outputs, plans, or state assertions.

---

## Phase 5 — AKS cluster baseline

**Status:** Complete for code and documentation. Azure deployment, network-capacity review, and private management-path verification are required before production use.

**Goal:** Create an AKS cluster capable of issuing OIDC tokens for workload identity while remaining appropriately secured.

### Code

- [x] Create the AKS cluster in `code/module/AKS/` using `azurerm_kubernetes_cluster`.
- [x] Enable OIDC issuer and AKS workload identity.
- [x] Attach the cluster to the dedicated AKS subnet.
- [x] Use managed identities for the control plane and kubelet; document their permissions.
- [x] Configure Microsoft Entra integration and Azure RBAC for Kubernetes using the selected and documented access model.
- [x] Define private-cluster, API access, network-plugin, service CIDR, DNS service IP, SKU, node pool, upgrade, and monitoring inputs explicitly.
- [x] Export only non-sensitive cluster outputs required by downstream modules, including OIDC issuer URL and cluster identity information.

### Documentation

- [x] Add AKS component and trust-boundary diagrams.
- [x] Create an AKS configuration decision record covering private/public API, network model, Entra integration, and version policy.
- [x] Document node, pod, service, and management address ranges.
- [x] Add a baseline operational guide for access, upgrades, backup/recovery boundaries, and audit logging.

### Exit criteria

- [x] The configuration enables OIDC issuer and workload identity; verify the deployed cluster reports both before use.
- [x] A documented pre-apply review requires the selected network model to avoid CIDR overlap with the VNet and connected networks.
- [x] Cluster and kubelet identities have documented, minimum necessary Azure permissions.

---

## Phase 6 — Federated workload identity and Key Vault RBAC

**Status:** Complete for Azure infrastructure and documentation. The Kubernetes service account and example workload are deliberately deferred to Phase 7.

**Goal:** Bind one Kubernetes service account to one user-assigned managed identity and grant that identity minimal Key Vault access.

### Code

- [x] Create a user-assigned managed identity for the sample workload.
- [x] Create an Entra federated identity credential with the AKS OIDC issuer, approved audience, and exact service-account subject (`system:serviceaccount:<namespace>:<service-account>`).
- [x] Create the required Key Vault data-plane role assignment at the narrowest supported scope.
- [x] Parameterise namespace and service-account name; derive the workload identity name and restrict the Key Vault role to `Key Vault Secrets User`.
- [x] Export identity client ID and resource ID only as needed by the Kubernetes workload example.
- [x] Add dependency ordering so OIDC and Key Vault prerequisites exist before the federation and role assignment.

### Documentation

- [x] Add the identity token-exchange sequence diagram.
- [x] Create the RBAC matrix: principal, role, scope, purpose, owner, and removal/review condition.
- [x] Create the threat model covering token theft, overly broad federated subjects, RBAC escalation, public exposure, and Terraform state/plan leakage.
- [x] Document the expected Kubernetes service-account annotations and workload labels.

### Exit criteria

- [x] The federated subject contains exactly one approved namespace and service account.
- [x] The runtime identity is distinct from Terraform and CI/CD identities.
- [x] The sample identity can retrieve only Key Vault secret content; it cannot modify infrastructure or read Key Vault keys/certificates.

---

## Phase 7 — Runnable Kubernetes workload example

**Status:** Complete for the repository example and documentation. A real deployment requires approved Azure credentials, private network access, a non-production Key Vault secret, and an approved image digest.

**Goal:** Give users a safe, observable proof that a pod authenticates through workload identity rather than a stored client secret.

### Code

- [x] Add `examples/basic-key-vault-access/` with a namespace, service account, and minimal workload Job.
- [x] Add the Azure Workload Identity label and service-account client-ID annotation required by the selected integration.
- [x] Use a non-sensitive test secret name; never output the secret plaintext as a test result.
- [x] Add a verification script and documented commands that prove token-based Key Vault access through a redacted secret identifier.
- [x] Add cleanup commands and resource ownership notes.

### Documentation

- [x] Add prerequisite checks, required Azure permissions, and cost warning.
- [x] Add step-by-step deploy, verify, troubleshoot, and cleanup instructions.
- [x] Include expected outcomes for success and common identity/DNS/RBAC failures without publishing tokens or secret contents.

### Exit criteria

- [x] A user with the stated prerequisites can complete the example from a clean checkout.
- [x] Verification proves access without printing a secret value.
- [x] Cleanup removes example-scoped resources and states which shared resources must not be destroyed automatically.

---

## Phase 8 — Tests, policy, CI/CD, and contributor workflow

**Goal:** Treat the Terraform implementation as production code with automated, repeatable quality evidence.

### Code

- [ ] Add a GitHub Actions workflow using OIDC to Azure; do not add an Azure client secret to repository secrets.
- [ ] Run `terraform fmt -check`, `terraform init -backend=false`, `terraform validate`, TFLint, and an IaC security scanner on pull requests.
- [ ] Add `terraform test` or equivalent tests for key invariants: public Key Vault access disabled, workload identity/OIDC enabled, dedicated private-endpoint subnet, and scoped role assignment.
- [ ] Generate a plan only for an approved disposable or review environment; store any plan artifact for a short retention period and prevent secret-bearing output.
- [ ] Add policy-as-code checks for required tags, private connectivity, recovery settings, and restricted network exposure.
- [ ] Protect applies behind an environment approval and separate plan/apply privilege where the platform supports it.

### Documentation

- [ ] Add `CONTRIBUTING.md` with local setup, authentication expectations, commands, testing rules, and documentation-change requirements.
- [ ] Add `documentation/testing-and-quality.md` mapping every check to a risk it mitigates.
- [ ] Add policy exception and review process documentation.
- [ ] Add CI identity permissions to the RBAC matrix.

### Exit criteria

- A pull request produces visible pass/fail evidence for format, validation, linting, security scan, and tests.
- No pipeline uses a long-lived Azure client secret.
- A failed security invariant demonstrably blocks the quality gate.

---

## Phase 9 — Public release and operational readiness

**Goal:** Publish a versioned, safe-to-consume module with sufficient operational and security information for external users.

### Code

- [ ] Review and stabilise input/output contracts.
- [ ] Add module outputs and generated input/output documentation where useful.
- [ ] Add release automation, tags, and changelog generation/review process.
- [ ] Create a clean-example validation run from a fresh checkout.
- [ ] Publish `v0.1.0` after the narrow path works; publish `v1.0.0` only after all documented release criteria are met.

### Documentation

- [ ] Finalise the README quick start, architecture diagram, compatibility matrix, and known limitations.
- [ ] Add `CHANGELOG.md`, `SECURITY.md`, licence, and `documentation/release-process.md`.
- [ ] Add incident/rollback and access-revocation runbooks.
- [ ] Review every public document for customer data, subscription/tenant IDs, tokens, secret values, internal IP ranges, and employer-specific material.
- [ ] Publish a short technical article or walkthrough only after the repository is safe for public sharing.

### Exit criteria for v1.0.0

- An external engineer can understand the module, deploy the example, verify identity-based Key Vault access without viewing secret plaintext, and clean up using published documentation.
- Architecture, identity flow, threat model, RBAC matrix, Terraform code, CI checks, and operations runbooks agree.
- The release is versioned, licensed, changelogged, security-reporting capable, and free from sensitive data.
- All required validation, tests, scans, and policy checks pass on the release commit.

## Change-completion checklist

Use this checklist for every resource or meaningful configuration change:

1. Add or change the Terraform resource in the appropriate module.
2. Add only the inputs, locals, outputs, and dependencies the resource needs.
3. Run formatting and Terraform validation; run focused tests/scans when available.
4. Update the relevant architecture, security, operational, and module-usage documentation.
5. Update the RBAC matrix and threat model for any identity, role, network, or secret-handling change.
6. Add or update an ADR when the decision has durable architectural, security, cost, or operational consequences.
7. Confirm no sensitive data appears in code, variable files, plans, state, logs, screenshots, or documentation.
