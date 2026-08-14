resource "aws_ssm_parameter" "step_applied" {
  name        = "/organization/automation/steps/08-networking-rollout"
  description = "Marker written when this step has been successfully applied"
  type        = "String"
  value       = "applied"
}

# Writes step outputs to SSM Parameter Store under /landing-zone/networking-rollout/
# Downstream steps read these via: data "aws_ssm_parameter" "<name>" { name = "..." }

# resource "aws_ssm_parameter" "ipam_id" {
#   name        = "/landing-zone/networking-rollout/ipam_id"
#   description = "VPC IPAM resource ID for IP address management"
#   type        = "String"
#   value       = aws_vpc_ipam.this.id
# }

# resource "aws_ssm_parameter" "ipam_pool_prod_id" {
#   name        = "/landing-zone/networking-rollout/ipam_pool_prod_id"
#   description = "IPAM pool ID allocated for production workloads"
#   type        = "String"
#   value       = aws_vpc_ipam_pool.prod.id
# }

# resource "aws_ssm_parameter" "ipam_pool_nonprod_id" {
#   name        = "/landing-zone/networking-rollout/ipam_pool_nonprod_id"
#   description = "IPAM pool ID allocated for non-production workloads"
#   type        = "String"
#   value       = aws_vpc_ipam_pool.nonprod.id
# }

# resource "aws_ssm_parameter" "corenetwork_id" {
#   name        = "/landing-zone/networking-rollout/corenetwork_id"
#   description = "CloudWAN CoreNetwork ID for SD-WAN connectivity"
#   type        = "String"
#   value       = aws_networkmanager_core_network.this.id
# }

# resource "aws_ssm_parameter" "corenetwork_arn" {
#   name        = "/landing-zone/networking-rollout/corenetwork_arn"
#   description = "CloudWAN CoreNetwork ARN for attachment policies"
#   type        = "String"
#   value       = aws_networkmanager_core_network.this.arn
# }

# resource "aws_ssm_parameter" "shared_phz_id" {
#   name        = "/landing-zone/networking-rollout/shared_phz_id"
#   description = "Route53 Private Hosted Zone ID shared across the organization"
#   type        = "String"
#   value       = aws_route53_zone.shared.id
# }

