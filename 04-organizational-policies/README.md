# Organizational Policies

## Overview

Defines and applies organizational-level guardrails using Service Control Policies (SCPs) and tagging policies.

## What This Step Deploys

- Service Control Policies (SCPs) for least-privilege access
- Tagging policies to enforce resource naming conventions
- Backup policies for organizational backup enforcement
- Policy attachments to OUs and accounts

## Key Inputs

- `aws_region` — Primary region
- `organization_id` — Organization ID (from Step 01)

## Key Outputs

- `scp_policy_ids` — Map of SCP policy IDs
- `tag_policy_ids` — Map of tagging policy IDs

## Dependencies

Step 01 (Organization and OUs must exist). Can run in parallel with Step 05.

## Files

- `main.tf` — Resource definitions
- `variables.tf` — Input variables and defaults
- `outputs.tf` — Exported data for downstream steps

## Running This Step

```bash
cd 04-organizational-policies
terraform init
terraform plan
terraform apply
```

## Next Steps

Proceed to `05-identity-center/`
