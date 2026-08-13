# AWS Landing Zone Deployment Sequence

## Overview
This repository deploys a complete AWS Organizations landing zone with Control Tower, security baselines, networking, and cost governance. Each step is a self-contained Terraform deployment with explicit sequential dependencies.

**Input variables** (common across all steps):
- `aws_region` — primary region for all resources
- `secondary_regions` — (TBD) optional list of secondary regions for replication / multi-region setup
- `environment` — (e.g., `prod`, `staging`, `poc`)
- `organization_name` — name of the AWS Organization

---

## Deployment Sequence

### Step 01: Organization Setup
**Target account:** Master  
**Depends on:** Nothing

Creates the foundational AWS Organizations structure.

**Outputs:**
- Organization ID
- Master account ID
- OU structure (root OU, then functional OUs)
- Member account IDs: Logging, Security, AFT, Networking, Identity, Observability

**Inputs:**
- `organization_name`
- `aws_region`

---

### Step 02: Control Tower Setup
**Target account:** Master  
**Depends on:** Step 01 (Organization exists)

Enrolls the organization in AWS Control Tower and sets sensible baseline controls.

**Outputs:**
- Control Tower enrollment status
- Audit account ID
- Centralized logging enabled (CloudTrail → Log Archive S3)

**Inputs:**
- `aws_region`
- `log_archive_account_id` (from Step 01)

---

### Step 03: Security Tooling Rollout
**Target account:** Security  
**Depends on:** Step 02 (CT enrollment + Log Archive active)

Deploys centralized security monitoring across the organization.

**Resources:**
- GuardDuty (org-wide delegation + enrollment)
- Security Hub (aggregation)
- AWS Config (aggregation)

**Outputs:**
- GuardDuty delegated administrator account
- Security Hub aggregation setup
- Config aggregation channel

**Inputs:**
- `aws_region`
- `security_account_id`
- `log_archive_account_id`
- `organization_id` (from Step 01)

---

### Step 04: Organizational Policies
**Target account:** Master  
**Depends on:** Step 01 (Organization exists)

Defines and applies organizational-level guardrails.

**Resources:**
- Service Control Policies (SCPs)
- Tag policies
- Backup policies (optional)

**Strategy:** Prioritize Control Tower default controls; supplement with custom SCPs for org-specific constraints.

**Inputs:**
- `aws_region`
- `organization_id`

---

### Step 05: IAM Identity Center & Identity Delegation
**Target account:** Master + Identity  
**Depends on:** Step 01 (Identity account exists)

Configures centralized identity and access management.

**Resources:**
- IAM Identity Center setup
- Directory (internal or connected to external IdP)
- Permission sets
- Account assignments to member accounts

**Assumes:** ControlTowerExecution role for cross-account setup to Identity account.

**Outputs:**
- Identity Center ARN
- Permission set ARNs

**Inputs:**
- `aws_region`
- `identity_account_id`
- `identity_center_display_name`

---

### Step 06: AFT Setup
**Target account:** Master + AFT + Log Archive + Audit  
**Depends on:** Step 02 (CT setup) + Step 05 (Identity configured)

Deploys Account Factory for Terraform for automated account provisioning.

**Resources:**
- AFT service roles in AFT account
- GitHub/CodeCommit repositories (control tower, account requests, account customizations)
- Account baseline templates (standard VPCs, endpoints, logging, tags)

**Outputs:**
- AFT governance repository URLs
- AFT service role ARNs

**Inputs:**
- `aws_region`
- `aft_account_id`
- `repository_provider` (GitHub / CodeCommit)

---

### Step 07: Networking Rollout
**Target account:** Networking + Organization (for IPAM/CoreNetwork sharing)  
**Depends on:** Step 06 (AFT account baseline deployed + Networking account ready)

Establishes the centralized network backbone.

**Resources:**
- VPC IPAM + address pools
- EC2 VPC (shared service VPC)
- AWS CloudWAN CoreNetwork + attachment policies
- Route53 Private Hosted Zone (shared to organization)
- IPAM sharing to organization

**Outputs:**
- IPAM pool IDs
- CoreNetwork ID
- Route53 Private Hosted Zone ID
- IPAM sharing principal ARN

**Inputs:**
- `aws_region`
- `secondary_regions` (TBD)
- `networking_account_id`
- `cidr_root_block` (e.g., `10.0.0.0/8`)
- `ipam_pool_tiers` (e.g., regional, per-env)

---

### Step 08: Cost Governance
**Target account:** Master  
**Depends on:** Step 01 (Organization exists) + Step 07 (Networking stable)

Configures cost monitoring and chargeback.

**Resources:**
- Billing consolidation
- Cost Anomaly Detection
- Budgets & alerts
- Chargeback tags (enforced via policy)

**Outputs:**
- Cost anomaly detector IDs
- Budget alert SNS topic ARN

**Inputs:**
- `aws_region`
- `cost_threshold_alerts`
- `chargeback_tag_key`

---

## Dependency Graph

```
01-organization-setup
│
├─→ 02-control-tower-setup
│   │
│   ├─→ 03-security-tooling-rollout
│   │
│   └─→ 06-aft-setup ←─┐
│       │               │
│       └─→ 07-networking-rollout ─┐
│           │                       │
│           └─→ 08-cost-governance ←┘
│
04-organizational-policies (independent after org setup)
│
└─→ 05-identity-center-setup
    └─→ 06-aft-setup (also depends on this)
```

---

## Adding a New Step

1. Create directory: `NN-step-description/`
2. Update `pr-validate.yml`: add two jobs (`validate-step-NN`, `plan-step-NN`) with appropriate `needs:`
3. Update `deploy.yml`: add two jobs (`plan-step-NN`, `apply-step-NN`) with appropriate `needs:` chain
4. Document inputs, outputs, and dependencies in this file

---

## Multi-Region Strategy

**Current:** Single primary region  
**Planned (TBD):** 
- Define secondary regions for disaster recovery
- Replicate centralized logging buckets
- CoreNetwork attachments in secondary regions
- VPC IPAM pools per region

To be implemented as follow-up steps after core landing zone is operational.

---

## Cross-Account Assumptions

All steps assume the ability to assume `ControlTowerExecution` role in target accounts (provisioned automatically by Control Tower). GitHub Actions credentials will be federated via OIDC to a role in the Master account.

