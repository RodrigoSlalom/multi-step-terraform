# Writes step outputs to SSM Parameter Store under /landing-zone/aft-setup/
# Downstream steps read these via: data "aws_ssm_parameter" "<name>" { name = "..." }

resource "aws_ssm_parameter" "aft_service_role_arn" {
  name        = "/landing-zone/aft-setup/aft_service_role_arn"
  description = "IAM role ARN used by AFT for account provisioning"
  type        = "String"
  value       = aws_iam_role.aft_service.arn
}

resource "aws_ssm_parameter" "aft_account_requests_repo" {
  name        = "/landing-zone/aft-setup/aft_account_requests_repo"
  description = "Repository URL for AFT account requests"
  type        = "String"
  value       = aws_codecommit_repository.account_requests.clone_url_http
}

resource "aws_ssm_parameter" "aft_customizations_repo" {
  name        = "/landing-zone/aft-setup/aft_customizations_repo"
  description = "Repository URL for AFT account customizations"
  type        = "String"
  value       = aws_codecommit_repository.account_customizations.clone_url_http
}

