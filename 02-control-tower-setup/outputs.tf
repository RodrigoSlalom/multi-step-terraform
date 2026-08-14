# Writes step outputs to SSM Parameter Store under /landing-zone/control-tower-setup/
# Downstream steps read these via: data "aws_ssm_parameter" "<name>" { name = "..." }

resource "aws_ssm_parameter" "landing_zone_arn" {
  name        = "/landing-zone/control-tower-setup/landing_zone_arn"
  description = "Control Tower landing zone ARN"
  type        = "String"
  value       = aws_controltower_landing_zone.this.arn
}

resource "aws_ssm_parameter" "audit_account_id" {
  name        = "/landing-zone/control-tower-setup/audit_account_id"
  description = "Audit account ID provisioned by Control Tower"
  type        = "String"
  value       = aws_controltower_landing_zone.this.audit_account_id
}

resource "aws_ssm_parameter" "cloudtrail_bucket_arn" {
  name        = "/landing-zone/control-tower-setup/cloudtrail_bucket_arn"
  description = "S3 bucket ARN for centralized CloudTrail logs"
  type        = "String"
  value       = aws_s3_bucket.cloudtrail.arn
}

