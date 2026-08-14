# Global Terraform Variables
#
# These variables are shared across all deployment steps.
# Step-specific values in step-variables.tfvars override these.

# Account ID for the central identity account.
central_identity_account_id = ""

# Master account ID for this organization.
satellite_master_account_id = ""

# Primary AWS region for the organization.
aws_region = ""

# Secondary AWS regions for multi-region setup (TBD).
aws_secondary_regions = []

# Name for this organization.
organization_name = ""
