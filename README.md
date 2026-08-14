# AWS Landing Zone Terraform Monorepo Template

This repository contains a complete AWS Organizations landing zone deployment using Terraform, structured as a series of sequential, self-contained deployment steps.

## Quick Start

See [DEPLOYMENT_SEQUENCE.md](./DEPLOYMENT_SEQUENCE.md) for the full 8-step sequence, dependency graph, and architecture.

## Directory Structure

```
.
├── 01-organization-setup/        # Create AWS Org, accounts, OUs
├── 02-control-tower-setup/       # Enroll in Control Tower, baseline controls
├── 03-security-tooling/          # GuardDuty, Security Hub, Config aggregation
├── 04-organizational-policies/   # SCPs, tagging policies
├── 05-identity-center/           # IAM Identity Center, permission sets
├── 06-aft-setup/                 # Account Factory for Terraform
├── 07-networking-rollout/        # IPAM, CloudWAN, Route53 PHZ
├── 08-cost-governance/           # Cost monitoring, anomaly detection, budgets
├── .github/
│   ├── workflows/
│   │   ├── pr-validate.yml       # PR validation: validate & plan all steps (parallel)
│   │   └── deploy.yml            # Deploy: respects dependency graph
│   └── actions/
│       └── tf-run/               # Composite action: terraform validate/plan/apply
├── DEPLOYMENT_SEQUENCE.md        # Detailed step documentation
└── README.md                      # This file
```

## Workflows

### PR Validation (`pr-validate.yml`)
Triggered on PR → `main`:
- **Validates** all steps in parallel
- **Plans** all steps in parallel (no execution)
- No environment gate — reviewers inspect plan output before merge

### Deploy (`deploy.yml`)
Triggered on push to `main`:
- Respects the documented dependency graph
- Steps run sequentially / in parallel based on dependencies
- Environment gate on **apply** jobs only — one approval per step

## Adding a New Step

1. Create directory: `NN-step-description/`
2. Create Terraform files: `variables.tf`, `main.tf`, `outputs.tf`
3. Document inputs, outputs, dependencies in [DEPLOYMENT_SEQUENCE.md](./DEPLOYMENT_SEQUENCE.md)
4. Update `pr-validate.yml`:
   - Add `validate-step-NN` job
   - Add `plan-step-NN` job with `needs: [validate-step-NN, ...]`
5. Update `deploy.yml`:
   - Add `plan-step-NN` job with `needs: [apply-step-X, apply-step-Y, ...]`
   - Add `apply-step-NN` job with `needs: plan-step-NN`

## Key Inputs

All steps accept common variables (see `*/variables.tf`):
- `aws_region` — primary region
- `aws_secondary_regions` — (TBD) secondary regions for multi-region setup
- `environment` — environment name (prod, staging, poc)
- `organization_name` — AWS Organization name

Step-specific inputs are documented in each step's `variables.tf`.

## Cross-Account Assumptions

All steps assume the ability to assume `ControlTowerExecution` role in target accounts. GitHub Actions credentials are federated via OIDC to the Master account.

## State Management

Each step maintains its own Terraform state (TBD: configure remote backend in `main.tf` for each step).

**Recommended:** S3 backend with DynamoDB state locking, state stored in the Log Archive account.

## Security

- Action versions pinned to full commit SHA
- Explicit `permissions:` blocks on all workflows and jobs
- Environment gates on all `apply` jobs
- No hardcoded secrets (use GitHub Secrets and OIDC)

See [copilot-instructions.md](./.github/copilot-instructions.md) for coding standards and security policies.
