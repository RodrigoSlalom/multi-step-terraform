# Writes step outputs to SSM Parameter Store under /landing-zone/organizational-policies/
# Downstream steps read these via: data "aws_ssm_parameter" "<name>" { name = "..." }

# resource "aws_ssm_parameter" "root_scp_id" {
#   name        = "/landing-zone/organizational-policies/root_scp_id"
#   description = "Root-level SCP applied to the organization"
#   type        = "String"
#   value       = aws_organizations_policy.root.id
# }

# resource "aws_ssm_parameter" "deny_region_scp_id" {
#   name        = "/landing-zone/organizational-policies/deny_region_scp_id"
#   description = "SCP that restricts workloads to approved AWS regions"
#   type        = "String"
#   value       = aws_organizations_policy.deny_non_approved_regions.id
# }

# resource "aws_ssm_parameter" "tagging_policy_id" {
#   name        = "/landing-zone/organizational-policies/tagging_policy_id"
#   description = "Tagging policy enforcing required resource tags"
#   type        = "String"
#   value       = aws_organizations_policy.tagging.id
# }

