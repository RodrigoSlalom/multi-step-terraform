# Writes step outputs to SSM Parameter Store under /landing-zone/organization-setup/
# Downstream steps read these via: data "aws_ssm_parameter" "<name>" { name = "..." }

resource "aws_ssm_parameter" "organization_id" {
  name        = "/landing-zone/organization-setup/organization_id"
  description = "Root AWS Organization ID"
  type        = "String"
  value       = aws_organizations_organization.this.id
}

resource "aws_ssm_parameter" "master_account_id" {
  name        = "/landing-zone/organization-setup/master_account_id"
  description = "Master (billing) account ID"
  type        = "String"
  value       = aws_organizations_organization.this.master_account_id
}

resource "aws_ssm_parameter" "log_archive_account_id" {
  name        = "/landing-zone/organization-setup/log_archive_account_id"
  description = "Log Archive account ID for centralized logging"
  type        = "String"
  value       = aws_organizations_account.log_archive.id
}

resource "aws_ssm_parameter" "security_account_id" {
  name        = "/landing-zone/organization-setup/security_account_id"
  description = "Security tooling account ID"
  type        = "String"
  value       = aws_organizations_account.security.id
}

resource "aws_ssm_parameter" "aft_account_id" {
  name        = "/landing-zone/organization-setup/aft_account_id"
  description = "Account Factory for Terraform account ID"
  type        = "String"
  value       = aws_organizations_account.aft.id
}

resource "aws_ssm_parameter" "networking_account_id" {
  name        = "/landing-zone/organization-setup/networking_account_id"
  description = "Centralized networking account ID"
  type        = "String"
  value       = aws_organizations_account.networking.id
}

resource "aws_ssm_parameter" "identity_account_id" {
  name        = "/landing-zone/organization-setup/identity_account_id"
  description = "IAM Identity Center account ID"
  type        = "String"
  value       = aws_organizations_account.identity.id
}

resource "aws_ssm_parameter" "observability_account_id" {
  name        = "/landing-zone/organization-setup/observability_account_id"
  description = "Observability and monitoring account ID"
  type        = "String"
  value       = aws_organizations_account.observability.id
}

