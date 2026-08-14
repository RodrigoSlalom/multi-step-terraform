# Networking Rollout

## Overview

Establishes the centralized network backbone including IPAM, CloudWAN, and DNS infrastructure.

## What This Step Deploys

- VPC IPAM (IP Address Management) with address pools
- Shared service VPC in Networking account
- AWS CloudWAN CoreNetwork for SD-WAN connectivity
- Route53 Private Hosted Zones (shared to organization)
- IPAM and Route53 PHZ sharing to organization

## Key Inputs

- `aws_region` — Primary region
- `aws_secondary_regions` — (TBD) Secondary regions for replication
- `networking_account_id` — Account ID for Networking (from Step 01)
- `cidr_root_block` — Root CIDR block for IPAM (e.g., 10.0.0.0/8)

## Key Outputs

- `ipam_pool_ids` — Map of IPAM pool IDs
- `corenetwork_id` — CloudWAN CoreNetwork ID
- `route53_phz_id` — Route53 Private Hosted Zone ID
- `ipam_sharing_arn` — ARN of IPAM sharing resource

## Dependencies

Step 06 (AFT must be set up; Networking account baseline must be deployed)

## Files

- `main.tf` — Resource definitions
- `variables.tf` — Input variables and defaults
- `outputs.tf` — Exported data for downstream steps

## Running This Step

```bash
cd 07-networking-rollout
terraform init
terraform plan
terraform apply
```

## Next Steps

Proceed to `08-cost-governance/`
