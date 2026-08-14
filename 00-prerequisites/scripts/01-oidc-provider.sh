#!/usr/bin/env bash
set -euo pipefail

PROVIDER_URL="https://token.actions.githubusercontent.com"
# Thumbprint is validated automatically by AWS for GitHub's well-known URL
THUMBPRINT="6938fd4d98bab03faadb97b34396831e3780aea1"

PROVIDER_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"

if [[ "${MODE:-apply}" == "destroy" ]]; then
  echo "Checking GitHub OIDC provider for deletion..."
  EXISTING=$(aws iam list-open-id-connect-providers \
    --query "OIDCProviderList[?ends_with(Arn, 'token.actions.githubusercontent.com')].Arn" \
    --output text)
  if [[ -z "$EXISTING" ]]; then
    echo "  Not found — skipping."
    exit 0
  fi
  echo "  Deleting OIDC provider..."
  aws iam delete-open-id-connect-provider --open-id-connect-provider-arn "$PROVIDER_ARN"
  echo "  Deleted: $PROVIDER_ARN"
  exit 0
fi

echo "Checking GitHub OIDC provider..."
EXISTING=$(aws iam list-open-id-connect-providers \
  --query "OIDCProviderList[?ends_with(Arn, 'token.actions.githubusercontent.com')].Arn" \
  --output text)

if [[ -n "$EXISTING" ]]; then
  echo "  Already exists: $EXISTING — skipping."
  exit 0
fi

echo "  Creating OIDC provider..."
aws iam create-open-id-connect-provider \
  --url "$PROVIDER_URL" \
  --client-id-list "sts.amazonaws.com" \
  --thumbprint-list "$THUMBPRINT"

echo "  Created: $PROVIDER_ARN"
