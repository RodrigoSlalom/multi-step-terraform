# 03-SECURITY-TOOLING
# Deploys GuardDuty, Security Hub, and Config aggregation
#
# Depends on:
#   - Previous step completion
# 
# Outputs:
#   - guardduty_detector_id
#   - security_hub_arn
#   - config_aggregator_arn

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
