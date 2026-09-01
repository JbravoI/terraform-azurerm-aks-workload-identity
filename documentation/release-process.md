# Release Process

## Before creating a release tag

1. Confirm the target commit passes the pull-request quality workflow.
2. Run the Phase 7 example from a clean checkout using a disposable/non-production Azure environment. Capture only redacted evidence.
3. Review inputs, outputs, compatibility notes, known limitations, ADRs, RBAC matrix, threat model, and operations guides for accuracy.
4. Review `CHANGELOG.md`; move releasable changes from **Unreleased** into the proposed version section.
5. Confirm no source, plan, artifact, screenshot, example, or documentation contains secrets, tokens, customer data, real subscription/tenant IDs, or internal network details.
6. Confirm a licence is selected and approved by the repository owner.
7. Confirm the target AzureRM provider version is represented by the committed root lock file.

## Versioning

Use semantic tags in the form `vMAJOR.MINOR.PATCH`.

- Use `v0.1.0` for the first public preview after the runnable example and quality gates are externally verified.
- Use `v1.0.0` only after the full Phase 9 definition of done is met.
- Document breaking input/output or security-posture changes in a migration section of the release note.

## Tag and release automation

Pushing a semantic version tag triggers `.github/workflows/release.yml`. It validates format, Terraform configuration, and module tests; packages the source; and creates a GitHub release with generated notes.

The workflow does not apply Terraform or publish infrastructure. Protect the tag-creation path and require review before creating a tag.

## Terraform Registry publication

Terraform Registry publication requires the repository owner to connect the public GitHub repository to the Terraform Registry and select the supported provider/module metadata. After that one-time setup, create a semantic GitHub release/tag that follows the release process above. Confirm the Registry page renders the README, inputs, outputs, version, and release notes correctly.

## After release

1. Verify the GitHub release, source archive, and—if configured—Terraform Registry version.
2. Test the quick start from a fresh checkout.
3. Record defects or usability findings as issues; do not quietly amend a release tag.
4. If a security issue is discovered, follow `SECURITY.md`, publish a remediation release, and document migration/rotation steps without exposing sensitive details.
