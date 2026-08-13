# 05-IDENTITY-CENTER
# Configures IAM Identity Center and permission sets
#
# Depends on:
#   - Previous step completion
# 
# Outputs:
#   - identity_center_arn
#   - identity_store_id
#   - permission_set_arns

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
