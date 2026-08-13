# 06-AFT-SETUP
# Deploys Account Factory for Terraform (AFT) for account provisioning
#
# Depends on:
#   - Previous step completion
# 
# Outputs:
#   - aft_service_role_arn
#   - aft_repository_urls

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
