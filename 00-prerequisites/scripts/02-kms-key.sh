#!/usr/bin/env bash
set -euo pipefail

KEY_ALIAS="alias/org-statefiles"

if [[ "${MODE:-apply}" == "destroy" ]]; then
  echo "Checking KMS key ($KEY_ALIAS) for deletion..."
  KEY_ID=$(aws kms describe-key --key-id "$KEY_ALIAS" \
    --query "KeyMetadata.KeyId" --output text 2>/dev/null || true)
  if [[ -z "$KEY_ID" ]]; then
    echo "  Not found — skipping."
    exit 0
  fi
  KEY_STATE=$(aws kms describe-key --key-id "$KEY_ID" \
    --query "KeyMetadata.KeyState" --output text)
  if [[ "$KEY_STATE" == "PendingDeletion" ]]; then
    echo "  Already pending deletion — skipping."
    exit 0
  fi
  echo "  Deleting alias and scheduling key deletion (7-day waiting period)..."
  aws kms delete-alias --alias-name "$KEY_ALIAS"
  aws kms schedule-key-deletion --key-id "$KEY_ID" --pending-window-in-days 7
  echo "  Key $KEY_ID scheduled for deletion in 7 days."
  exit 0
fi

echo "Checking KMS key ($KEY_ALIAS)..."
KEY_ID=$(aws kms describe-key --key-id "$KEY_ALIAS" \
  --query "KeyMetadata.KeyId" --output text 2>/dev/null || true)

if [[ -n "$KEY_ID" ]]; then
  echo "  Already exists: $KEY_ID — skipping."
  exit 0
fi

echo "  Creating KMS key..."
KEY_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM root permissions",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${AWS_ACCOUNT_ID}:root" },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
)

KEY_ID=$(aws kms create-key \
  --description "Terraform state file encryption for AWS Organizations landing zone" \
  --key-usage ENCRYPT_DECRYPT \
  --policy "$KEY_POLICY" \
  --query "KeyMetadata.KeyId" \
  --output text)

aws kms enable-key-rotation --key-id "$KEY_ID"
aws kms create-alias --alias-name "$KEY_ALIAS" --target-key-id "$KEY_ID"

echo "  Created and aliased: $KEY_ID"
