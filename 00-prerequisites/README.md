# Prerequisites Bootstrap

Run **once** before any Terraform automation in this repository. Creates the AWS resources that the GitHub Actions workflows depend on: OIDC federation, a KMS-encrypted state bucket, and the IAM roles assumed by CI jobs.

## Requirements

- AWS CLI configured with administrator credentials to the master account
- `gh` CLI authenticated to the GitHub repository (`gh auth login`)
- `jq` installed locally

## Setup

```bash
cp config.env.example config.env
# edit config.env
./bootstrap.sh
```

## Teardown

```bash
./bootstrap.sh --delete
```

Prompts for confirmation. The KMS key enters a 7-day pending-deletion window before it is permanently destroyed.

## What it creates

| Script | Resource |
|---|---|
| `01-oidc-provider.sh` | IAM OIDC provider for `token.actions.githubusercontent.com` |
| `02-kms-key.sh` | KMS key (`alias/org-statefiles`) with rotation enabled |
| `03-state-bucket.sh` | S3 bucket for Terraform state — versioned, SSE-KMS, public access blocked, TLS enforced |
| `04-iam-roles.sh` | `github-plan-role` (ReadOnly + state backend) and `github-apply-role` (Admin + state backend) |

The state bucket name is derived automatically: `<short-region>-<account-id>-organization-tf-statefiles`.

## IAM role trust scopes

| Role | Trusted event |
|---|---|
| `github-plan-role` | `pull_request` — used by the PR validation workflow |
| `github-apply-role` | `ref:refs/heads/main` — used by the deploy workflow |

## Idempotency

Every script checks whether its resource already exists before attempting to create it. Re-running `bootstrap.sh` against an account where the bootstrap has already been applied is safe.
