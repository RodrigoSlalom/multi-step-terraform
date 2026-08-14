#!/usr/bin/env bash
set -euo pipefail

PLAN_ROLE="github-plan-role"
APPLY_ROLE="github-apply-role"

delete_role() {
  local role="$1"
  echo "Checking $role for deletion..."
  if ! aws iam get-role --role-name "$role" &>/dev/null; then
    echo "  Not found — skipping."
    return
  fi
  echo "  Detaching managed policies..."
  aws iam list-attached-role-policies --role-name "$role" \
    --query 'AttachedPolicies[].PolicyArn' --output text | \
    tr '\t' '\n' | while read -r arn; do
      [[ -z "$arn" ]] && continue
      aws iam detach-role-policy --role-name "$role" --policy-arn "$arn"
    done
  echo "  Deleting inline policies..."
  aws iam list-role-policies --role-name "$role" \
    --query 'PolicyNames[]' --output text | \
    tr '\t' '\n' | while read -r name; do
      [[ -z "$name" ]] && continue
      aws iam delete-role-policy --role-name "$role" --policy-name "$name"
    done
  aws iam delete-role --role-name "$role"
  echo "  Deleted: $role"
}

if [[ "${MODE:-apply}" == "destroy" ]]; then
  delete_role "$APPLY_ROLE"
  delete_role "$PLAN_ROLE"
  exit 0
fi

OIDC_PROVIDER_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"
REPO="${GITHUB_ORG}/${GITHUB_REPO}"

KEY_ARN=$(aws kms describe-key --key-id "alias/org-statefiles" \
  --query "KeyMetadata.Arn" --output text)

STATE_BUCKET_ARN="arn:aws:s3:::${STATE_BUCKET_NAME}"

# Inline policy granting access to state backend resources
STATE_BACKEND_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "StateFileAccess",
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": "${STATE_BUCKET_ARN}/*"
    },
    {
      "Sid": "StateBucketList",
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:GetBucketVersioning"],
      "Resource": "${STATE_BUCKET_ARN}"
    },
    {
      "Sid": "StateKMS",
      "Effect": "Allow",
      "Action": ["kms:GenerateDataKey", "kms:Decrypt", "kms:DescribeKey"],
      "Resource": "${KEY_ARN}"
    }
  ]
}
EOF
)

# ── github-plan-role ──────────────────────────────────────────────────────────
PLAN_ROLE="github-plan-role"
echo "Checking $PLAN_ROLE..."

if aws iam get-role --role-name "$PLAN_ROLE" &>/dev/null; then
  echo "  Already exists — skipping."
else
  echo "  Creating $PLAN_ROLE..."

  PLAN_TRUST=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Federated": "${OIDC_PROVIDER_ARN}" },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {
        "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
        "token.actions.githubusercontent.com:sub": "repo:${REPO}:pull_request"
      }
    }
  }]
}
EOF
)

  aws iam create-role \
    --role-name "$PLAN_ROLE" \
    --assume-role-policy-document "$PLAN_TRUST" \
    --description "GitHub Actions — terraform plan on pull requests"

  aws iam attach-role-policy \
    --role-name "$PLAN_ROLE" \
    --policy-arn "arn:aws:iam::aws:policy/ReadOnlyAccess"

  aws iam put-role-policy \
    --role-name "$PLAN_ROLE" \
    --policy-name "state-backend-access" \
    --policy-document "$STATE_BACKEND_POLICY"

  echo "  Created: arn:aws:iam::${AWS_ACCOUNT_ID}:role/$PLAN_ROLE"
fi

# ── github-apply-role ─────────────────────────────────────────────────────────
APPLY_ROLE="github-apply-role"
echo "Checking $APPLY_ROLE..."

if aws iam get-role --role-name "$APPLY_ROLE" &>/dev/null; then
  echo "  Already exists — skipping."
else
  echo "  Creating $APPLY_ROLE..."

  APPLY_TRUST=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Federated": "${OIDC_PROVIDER_ARN}" },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {
        "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
        "token.actions.githubusercontent.com:sub": "repo:${REPO}:ref:refs/heads/main"
      }
    }
  }]
}
EOF
)

  aws iam create-role \
    --role-name "$APPLY_ROLE" \
    --assume-role-policy-document "$APPLY_TRUST" \
    --description "GitHub Actions — terraform apply on pushes to main"

  aws iam attach-role-policy \
    --role-name "$APPLY_ROLE" \
    --policy-arn "arn:aws:iam::aws:policy/AdministratorAccess"

  aws iam put-role-policy \
    --role-name "$APPLY_ROLE" \
    --policy-name "state-backend-access" \
    --policy-document "$STATE_BACKEND_POLICY"

  echo "  Created: arn:aws:iam::${AWS_ACCOUNT_ID}:role/$APPLY_ROLE"
fi
