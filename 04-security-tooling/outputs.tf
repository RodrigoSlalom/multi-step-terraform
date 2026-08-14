resource "aws_ssm_parameter" "step_applied" {
  name        = "/organization/automation/steps/04-security-tooling"
  description = "Marker written when this step has been successfully applied"
  type        = "String"
  value       = "applied"
}

# Writes step outputs to SSM Parameter Store under /landing-zone/security-tooling/
# Downstream steps read these via: data "aws_ssm_parameter" "<name>" { name = "..." }

# resource "aws_ssm_parameter" "guardduty_detector_id" {
#   name        = "/landing-zone/security-tooling/guardduty_detector_id"
#   description = "GuardDuty delegated administrator account ID"
#   type        = "String"
#   value       = aws_guardduty_organization_admin_account.this.admin_account_id
# }

# resource "aws_ssm_parameter" "security_hub_arn" {
#   name        = "/landing-zone/security-tooling/security_hub_arn"
#   description = "Security Hub findings aggregator ARN"
#   type        = "String"
#   value       = aws_securityhub_finding_aggregator.this.arn
# }

# resource "aws_ssm_parameter" "config_aggregator_arn" {
#   name        = "/landing-zone/security-tooling/config_aggregator_arn"
#   description = "AWS Config organization aggregator ARN"
#   type        = "String"
#   value       = aws_config_configuration_aggregator.this.arn
# }

