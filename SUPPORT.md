# Support policy

## What this project supports

This is a Terraform reference implementation for one private AKS cluster, one
Kubernetes workload identity, and least-privilege Key Vault secret-read access.
Supported tool and platform baselines are documented in
[documentation/compatibility.md](documentation/compatibility.md).

## How to get help

- Use GitHub Discussions for usage questions, architecture discussion, and
  deployment guidance that does not expose sensitive environment details.
- Use a GitHub Issue for a reproducible bug, documentation error, or a narrowly
  scoped enhancement. Search existing reports first.
- Follow [SECURITY.md](SECURITY.md) for a suspected vulnerability or credential
  exposure; do not report these in public.

## Maintainer response goals

The maintainer aims to acknowledge new issues and discussions within three
business days. Response times are goals, not a service-level agreement. This
project provides no managed-service support, production warranty, or emergency
response commitment.

## Before opening a report

Remove secrets, tokens, private IP ranges, Azure subscription/tenant IDs,
customer information, and unredacted Terraform plans/logs. Include the project
version, Terraform and provider versions, redacted error output, and safe
reproduction steps.

