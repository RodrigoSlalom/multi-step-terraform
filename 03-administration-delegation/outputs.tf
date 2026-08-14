resource "aws_ssm_parameter" "step_applied" {
  name        = "/organization/automation/steps/03-administration-delegation"
  description = "Marker written when this step has been successfully applied"
  type        = "String"
  value       = "applied"
}

# Writes step outputs to SSM Parameter Store under /landing-zone/administration-delegation/
# Downstream steps read these via: data "aws_ssm_parameter" "<name>" { name = "..." }

# resource "aws_ssm_parameter" "delegated_security_account_id" {
#   name        = "/landing-zone/administration-delegation/delegated_security_account_id"
#   description = "Security account ID delegated as admin for GuardDuty, Security Hub, and Config"
#   type        = "String"
#   value       = aws_organizations_delegated_administrator.security.account_id
# }

# resource "aws_ssm_parameter" "delegated_identity_account_id" {
#   name        = "/landing-zone/administration-delegation/delegated_identity_account_id"
#   description = "Identity account ID delegated as admin for IAM Identity Center"
#   type        = "String"
#   value       = aws_organizations_delegated_administrator.identity_center.account_id
# }

# resource "aws_ssm_parameter" "delegated_networking_account_id" {
#   name        = "/landing-zone/administration-delegation/delegated_networking_account_id"
#   description = "Networking account ID delegated as admin for IPAM and CloudWAN"
#   type        = "String"
#   value       = aws_organizations_delegated_administrator.networking.account_id
# }

# resource "aws_ssm_parameter" "delegated_observability_account_id" {
#   name        = "/landing-zone/administration-delegation/delegated_observability_account_id"
#   description = "Observability account ID delegated as admin for CloudWatch and X-Ray"
#   type        = "String"
#   value       = aws_organizations_delegated_administrator.observability.account_id
# }
