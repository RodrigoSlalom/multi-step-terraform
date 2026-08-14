# AWS Organizations Setup

## Overview

Creates the foundational AWS Organizations structure, including the organization itself and all member accounts.

## What This Step Deploys

- AWS Organizations
- Master account (billing account)
- Organizational Units (OUs) for functional areas
- Member accounts: Logging, Security, AFT, Networking, Identity, Observability

## Key Inputs

- `organization_name` — Name of the AWS Organization
- `aws_region` — Primary region for resources
- `environment` — Environment identifier (prod/staging/poc)

## Key Outputs

- `organization_id` — AWS Organization ID
- `master_account_id` — Master/billing account ID
- `member_accounts` — Map of account names to IDs
- `ou_structure` — Organizational Unit hierarchy

## Dependencies

None — this is the first step

## Files

- `main.tf` — Resource definitions
- `variables.tf` — Input variables and defaults
- `outputs.tf` — Exported data for downstream steps

## Running This Step

```bash
cd 01-organization-setup
terraform init
terraform plan
terraform apply
```

## Next Steps

Proceed to `02-control-tower-setup/`
