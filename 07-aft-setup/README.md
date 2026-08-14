# Account Factory for Terraform (AFT) Setup

## Overview

Deploys Account Factory for Terraform to automate account provisioning and baseline configurations across the organization.

## What This Step Deploys

- AFT service roles in AFT account
- AFT governance repository (GitHub/CodeCommit)
- Account request repository for automation
- Account customization repository for baselines
- Account baseline templates (VPC, IAM, logging, tags)

## Key Inputs

- `aws_region` — Primary region
- `aft_account_id` — Account ID for AFT (from Step 01)
- `repository_provider` — GitHub or CodeCommit

## Key Outputs

- `aft_service_role_arn` — ARN of AFT service role
- `aft_repository_urls` — Map of AFT repository URLs

## Dependencies

Step 02 (Control Tower) AND Step 05 (Identity Center). AFT account baseline must be deployed by Step 02.

## Files

- `main.tf` — Resource definitions
- `variables.tf` — Input variables and defaults
- `outputs.tf` — Exported data for downstream steps

## Running This Step

```bash
cd 06-aft-setup
terraform init
terraform plan
terraform apply
```

## Next Steps

Proceed to `07-networking-rollout/`
