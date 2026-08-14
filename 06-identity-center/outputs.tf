# Writes step outputs to SSM Parameter Store under /landing-zone/identity-center/
# Downstream steps read these via: data "aws_ssm_parameter" "<name>" { name = "..." }

# resource "aws_ssm_parameter" "identity_center_arn" {
#   name        = "/landing-zone/identity-center/identity_center_arn"
#   description = "IAM Identity Center instance ARN"
#   type        = "String"
#   value       = aws_ssoadmin_instances.this.arns[0]
# }

# resource "aws_ssm_parameter" "identity_store_id" {
#   name        = "/landing-zone/identity-center/identity_store_id"
#   description = "Identity store ID for user and group management"
#   type        = "String"
#   value       = aws_ssoadmin_instances.this.identity_store_ids[0]
# }

# resource "aws_ssm_parameter" "admin_permission_set_arn" {
#   name        = "/landing-zone/identity-center/admin_permission_set_arn"
#   description = "Permission set ARN for administrative access"
#   type        = "String"
#   value       = aws_ssoadmin_permission_set.admin.arn
# }

# resource "aws_ssm_parameter" "readonly_permission_set_arn" {
#   name        = "/landing-zone/identity-center/readonly_permission_set_arn"
#   description = "Permission set ARN for read-only access"
#   type        = "String"
#   value       = aws_ssoadmin_permission_set.readonly.arn
# }

