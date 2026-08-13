# 01-ORGANIZATION-SETUP
# Creates AWS Organizations and member accounts
#
# Depends on:
#   - Previous step completion
# 
# Outputs:
#   - organization_id
#   - master_account_id
#   - member_accounts
#   - ou_structure

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
