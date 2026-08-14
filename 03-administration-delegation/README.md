# Administration Delegation

## Overview

Delegates service administrators to specialized accounts using `aws_organizations_delegated_administrator`. This must run before any service is configured from within the delegated account — you cannot enroll accounts in GuardDuty or configure IAM Identity Center until the delegations exist.

## What This Step Deploys

- GuardDuty delegated administrator → Security account
- Security Hub delegated administrator → Security account
- AWS Config delegated administrator → Security account
- IAM Identity Center delegated administrator → Identity account
- VPC IPAM delegated administrator → Networking account
- AWS CloudWAN delegated administrator → Networking account
- CloudWatch and X-Ray delegated administrator → Observability account

## Key Inputs

- `aws_region` — Primary region
- `organization_name` — Organization name

All account IDs are read from SSM (written by Step 01):
- `/landing-zone/organization-setup/security_account_id`
- `/landing-zone/organization-setup/identity_account_id`
- `/landing-zone/organization-setup/networking_account_id`
- `/landing-zone/organization-setup/observability_account_id`

## Key Outputs

- `delegated_security_account_id` — Security account confirmed as delegated admin
- `delegated_identity_account_id` — Identity account confirmed as delegated admin
- `delegated_networking_account_id` — Networking account confirmed as delegated admin
- `delegated_observability_account_id` — Observability account confirmed as delegated admin

## Dependencies

Step 01 (accounts must exist) AND Step 02 (Control Tower must be enrolled; CT enables the AWS service delegations).

## Files

- `main.tf` — Resource definitions
- `variables.tf` — Input variables and defaults
- `outputs.tf` — SSM parameter exports for downstream steps
- `providers.tf` — Terraform and provider configuration

## Running This Step

```bash
cd 03-administration-delegation
terraform init
terraform plan
terraform apply
```

## Next Steps

Proceed to `04-security-tooling/`
