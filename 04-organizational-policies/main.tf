# 04-ORGANIZATIONAL-POLICIES
# Applies SCPs and tagging policies across the organization
#
# Depends on:
#   - Previous step completion
# 
# Outputs:
#   - scp_policy_ids
#   - tag_policy_ids

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # TODO: Configure remote backend (S3 + DynamoDB for state locking)
}

provider "aws" {
  region = var.aws_region
}

# Add resources below
