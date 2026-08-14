variable "aws_region" {
  description = "Primary AWS region"
  type        = string
}

variable "aws_secondary_regions" {
  description = "Secondary regions for multi-region setup (TBD)"
  type        = list(string)
  default     = []
}

variable "organization_name" {
  description = "Organization name"
  type        = string
}

# Step-specific variables go below
