# IAM Identity Center & Identity Delegation

## Overview

Configures centralized identity management using AWS IAM Identity Center with permission sets and account assignments.

## What This Step Deploys

- AWS IAM Identity Center (successor to AWS SSO)
- Directory configuration (local or external IdP)
- Permission sets for common administrative roles
- Account assignments to member accounts
- User and group synchronization

## Key Inputs

- `aws_region` — Primary region
- `identity_account_id` — Account ID for Identity resources (from Step 01)
- `identity_center_display_name` — Display name for the Identity Center portal

## Key Outputs

- `identity_center_arn` — ARN of Identity Center instance
- `identity_store_id` — Identity store ID
- `permission_set_arns` — Map of permission set ARNs

## Dependencies

Step 01 (Identity account must exist). Can run in parallel with Step 04.

## Files

- `main.tf` — Resource definitions
- `variables.tf` — Input variables and defaults
- `outputs.tf` — Exported data for downstream steps

## Running This Step

```bash
cd 05-identity-center
terraform init
terraform plan
terraform apply
```

## Next Steps

Proceed to `06-aft-setup/`
