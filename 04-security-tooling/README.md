# Security Tooling Rollout

## Overview

Deploys centralized security monitoring and compliance tools across the organization.

## What This Step Deploys

- AWS GuardDuty (organization-wide threat detection)
- Security Hub aggregation (centralized security findings)
- AWS Config aggregation (compliance and configuration tracking)
- Delegation of administrator access to Security account

## Key Inputs

- `aws_region` — Primary region for tools
- `security_account_id` — Account ID for Security tools (from Step 01)
- `organization_id` — Organization ID (from Step 01)

## Key Outputs

- `guardduty_detector_id` — GuardDuty detector resource ID
- `security_hub_arn` — Security Hub aggregation hub ARN
- `config_aggregator_arn` — AWS Config aggregator ARN

## Dependencies

Step 02 (Control Tower must be enrolled; centralized logging must be active)

## Files

- `main.tf` — Resource definitions
- `variables.tf` — Input variables and defaults
- `outputs.tf` — Exported data for downstream steps

## Running This Step

```bash
cd 03-security-tooling
terraform init
terraform plan
terraform apply
```

## Next Steps

Proceed to `04-organizational-policies/`
