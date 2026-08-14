# Cost Governance

## Overview

Configures cost monitoring, anomaly detection, and chargeback mechanisms across the organization.

## What This Step Deploys

- AWS Billing Consolidation (Linked Accounts)
- Cost Anomaly Detection with alerts
- AWS Budgets with alerts and notifications
- Chargeback tags (enforced via policies)
- Cost allocation tags and reports

## Key Inputs

- `aws_region` — Primary region
- `cost_threshold_alerts` — Cost thresholds for anomaly alerts
- `chargeback_tag_key` — Tag key for cost allocation

## Key Outputs

- `cost_anomaly_detector_ids` — List of detector IDs
- `budget_alert_topic_arn` — SNS topic ARN for budget alerts

## Dependencies

Step 01 (Organization) AND Step 07 (Networking must be complete to have stable infrastructure costs)

## Files

- `main.tf` — Resource definitions
- `variables.tf` — Input variables and defaults
- `outputs.tf` — Exported data for downstream steps

## Running This Step

```bash
cd 08-cost-governance
terraform init
terraform plan
terraform apply
```

## Next Steps

Landing zone initialization is complete.
