# AWS Control Tower Setup

## Overview

Enrolls the organization in AWS Control Tower and applies baseline security controls and guardrails.

## What This Step Deploys

- AWS Control Tower enrollment
- Audit account (for compliance tracking)
- Centralized logging to Log Archive account
- Default Control Tower guardrails and controls
- CloudTrail organization trail logging to S3

## Key Inputs

- `aws_region` — Primary region for Control Tower
- `log_archive_account_id` — Account ID for centralized logs (from Step 01)

## Key Outputs

- `control_tower_arn` — ARN of the Control Tower resource
- `audit_account_id` — Audit account ID created by Control Tower
- `logging_account_id` — Log Archive account ID
- `cloudtrail_bucket_arn` — S3 bucket for centralized logs

## Dependencies

Step 01 (Organization must exist)

## Files

- `main.tf` — Resource definitions
- `variables.tf` — Input variables and defaults
- `outputs.tf` — Exported data for downstream steps

## Running This Step

```bash
cd 02-control-tower-setup
terraform init
terraform plan
terraform apply
```

## Next Steps

Proceed to `03-security-tooling/`
