terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # bucket and region injected via -backend-config=../backend.hcl at terraform init
    key        = "01-organization-setup/terraform.tfstate"
    encrypt    = true
    kms_key_id = "alias/org-statefiles"
  }
}

provider "aws" {
  region = var.aws_region
}
