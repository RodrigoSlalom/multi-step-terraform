resource "aws_ssm_parameter" "step_applied" {
  name        = "/organization/automation/steps/09-cost-governance"
  description = "Marker written when this step has been successfully applied"
  type        = "String"
  value       = "applied"
}

# Writes step outputs to SSM Parameter Store under /landing-zone/cost-governance/
# Downstream steps read these via: data "aws_ssm_parameter" "<name>" { name = "..." }

# resource "aws_ssm_parameter" "anomaly_monitor_arn" {
#   name        = "/landing-zone/cost-governance/anomaly_monitor_arn"
#   description = "Cost anomaly monitor ARN for spend deviation alerts"
#   type        = "String"
#   value       = aws_ce_anomaly_monitor.this.arn
# }

# resource "aws_ssm_parameter" "budget_alert_topic_arn" {
#   name        = "/landing-zone/cost-governance/budget_alert_topic_arn"
#   description = "SNS topic ARN for budget threshold notifications"
#   type        = "String"
#   value       = aws_sns_topic.budget_alerts.arn
# }

