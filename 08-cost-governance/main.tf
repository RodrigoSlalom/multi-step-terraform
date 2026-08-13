# 08-COST-GOVERNANCE
# Configures cost monitoring, anomaly detection, and chargeback
#
# Depends on:
#   - Previous step completion
# 
# Outputs:
#   - cost_anomaly_detector_ids
#   - budget_alert_topic_arn

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
