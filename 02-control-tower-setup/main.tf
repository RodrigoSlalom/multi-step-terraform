# 02-CONTROL-TOWER-SETUP
# Enrolls organization in Control Tower with baseline controls
#
# Depends on:
#   - Previous step completion
# 
# Outputs:
#   - control_tower_arn
#   - audit_account_id
#   - logging_account_id

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
