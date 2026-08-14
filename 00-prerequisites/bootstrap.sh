#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="apply"

for arg in "$@"; do
  case "$arg" in
    --delete) MODE="destroy" ;;
    *) echo "ERROR: Unknown argument: $arg" >&2; exit 1 ;;
  esac
done

# Load configuration
CONFIG_FILE="$SCRIPT_DIR/config.env"
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "ERROR: $CONFIG_FILE not found. Copy config.env.example and fill in the values." >&2
  exit 1
fi
# shellcheck source=config.env
source "$CONFIG_FILE"

# Validate required variables
required_vars=(AWS_ACCOUNT_ID AWS_REGION GITHUB_ORG GITHUB_REPO)
for var in "${required_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "ERROR: $var is not set in config.env" >&2
    exit 1
  fi
done

# Verify caller identity matches expected account
CALLER_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
if [[ "$CALLER_ACCOUNT" != "$AWS_ACCOUNT_ID" ]]; then
  echo "ERROR: Current AWS identity is account $CALLER_ACCOUNT, expected $AWS_ACCOUNT_ID" >&2
  exit 1
fi

# Derive bucket name deterministically from region and account ID
SHORT_REGION=$(echo "$AWS_REGION" | sed -E 's/northeast/ne/g; s/northwest/nw/g; s/southeast/se/g; s/southwest/sw/g; s/east/e/g; s/west/w/g; s/north/n/g; s/south/s/g; s/central/c/g; s/-//g')
STATE_BUCKET_NAME="${SHORT_REGION}-${AWS_ACCOUNT_ID}-organization-tf-statefiles"

export AWS_ACCOUNT_ID AWS_REGION GITHUB_ORG GITHUB_REPO STATE_BUCKET_NAME MODE

run_script() {
  local script="$SCRIPT_DIR/scripts/$1"
  echo "──────────────────────────────────────────"
  echo "Running: $1 (mode: $MODE)"
  echo "──────────────────────────────────────────"
  bash "$script"
  echo ""
}

if [[ "$MODE" == "destroy" ]]; then
  echo "==> Tearing down prerequisites for account $AWS_ACCOUNT_ID in $AWS_REGION"
  echo "    WARNING: The KMS key will be scheduled for deletion (7-day waiting period)."
  echo ""
  read -r -p "Type 'yes' to confirm teardown: " confirm
  [[ "$confirm" == "yes" ]] || { echo "Aborted."; exit 0; }
  echo ""
  run_script 04-iam-roles.sh
  run_script 03-state-bucket.sh
  run_script 02-kms-key.sh
  run_script 01-oidc-provider.sh
  echo "──────────────────────────────────────────"
  echo "Removing GitHub repository variables"
  echo "──────────────────────────────────────────"
  gh variable delete AWS_BACKEND_BUCKET --repo "${GITHUB_ORG}/${GITHUB_REPO}" 2>/dev/null || true
  gh variable delete AWS_BACKEND_REGION --repo "${GITHUB_ORG}/${GITHUB_REPO}" 2>/dev/null || true
  echo ""
  echo "==> Teardown complete."
else
  echo "==> Bootstrapping prerequisites for account $AWS_ACCOUNT_ID in $AWS_REGION"
  echo ""
  run_script 01-oidc-provider.sh
  run_script 02-kms-key.sh
  run_script 03-state-bucket.sh
  run_script 04-iam-roles.sh
  echo "──────────────────────────────────────────"
  echo "Setting GitHub repository variables"
  echo "──────────────────────────────────────────"
  gh variable set AWS_BACKEND_BUCKET --body "$STATE_BUCKET_NAME" --repo "${GITHUB_ORG}/${GITHUB_REPO}"
  gh variable set AWS_BACKEND_REGION --body "$AWS_REGION" --repo "${GITHUB_ORG}/${GITHUB_REPO}"
  echo ""
  echo "==> Bootstrap complete."
fi
