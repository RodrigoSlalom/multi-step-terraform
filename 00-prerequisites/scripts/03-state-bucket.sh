#!/usr/bin/env bash
set -euo pipefail

if [[ "${MODE:-apply}" == "destroy" ]]; then
  echo "Checking state S3 bucket ($STATE_BUCKET_NAME) for deletion..."
  if ! aws s3api head-bucket --bucket "$STATE_BUCKET_NAME" 2>/dev/null; then
    echo "  Not found — skipping."
    exit 0
  fi

  echo "  Removing all object versions and delete markers..."
  # Remove all versions
  aws s3api list-object-versions --bucket "$STATE_BUCKET_NAME" \
    --query 'Versions[].{Key:Key,VersionId:VersionId}' --output json | \
    jq -r '.[] | "\(.Key) \(.VersionId)"' | \
  while read -r key version; do
    aws s3api delete-object --bucket "$STATE_BUCKET_NAME" --key "$key" --version-id "$version"
  done

  # Remove all delete markers
  aws s3api list-object-versions --bucket "$STATE_BUCKET_NAME" \
    --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output json | \
    jq -r '.[] | "\(.Key) \(.VersionId)"' | \
  while read -r key version; do
    aws s3api delete-object --bucket "$STATE_BUCKET_NAME" --key "$key" --version-id "$version"
  done

  echo "  Deleting bucket..."
  aws s3api delete-bucket --bucket "$STATE_BUCKET_NAME" --region "$AWS_REGION"
  echo "  Deleted: s3://$STATE_BUCKET_NAME"
  exit 0
fi

echo "Checking state S3 bucket ($STATE_BUCKET_NAME)..."

if aws s3api head-bucket --bucket "$STATE_BUCKET_NAME" 2>/dev/null; then
  echo "  Already exists — skipping creation."
else
  echo "  Creating bucket..."
  if [[ "$AWS_REGION" == "us-east-1" ]]; then
    aws s3api create-bucket --bucket "$STATE_BUCKET_NAME" --region "$AWS_REGION"
  else
    aws s3api create-bucket --bucket "$STATE_BUCKET_NAME" --region "$AWS_REGION" \
      --create-bucket-configuration LocationConstraint="$AWS_REGION"
  fi
fi

KEY_ARN=$(aws kms describe-key --key-id "alias/org-statefiles" \
  --query "KeyMetadata.Arn" --output text)

echo "  Applying bucket configuration..."

aws s3api put-public-access-block --bucket "$STATE_BUCKET_NAME" \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

aws s3api put-bucket-versioning --bucket "$STATE_BUCKET_NAME" \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption --bucket "$STATE_BUCKET_NAME" \
  --server-side-encryption-configuration "{
    \"Rules\": [{
      \"ApplyServerSideEncryptionByDefault\": {
        \"SSEAlgorithm\": \"aws:kms\",
        \"KMSMasterKeyID\": \"$KEY_ARN\"
      },
      \"BucketKeyEnabled\": true
    }]
  }"

BUCKET_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnencryptedUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${STATE_BUCKET_NAME}/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "aws:kms"
        }
      }
    },
    {
      "Sid": "DenyNonTLS",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${STATE_BUCKET_NAME}",
        "arn:aws:s3:::${STATE_BUCKET_NAME}/*"
      ],
      "Condition": {
        "Bool": { "aws:SecureTransport": "false" }
      }
    }
  ]
}
EOF
)
aws s3api put-bucket-policy --bucket "$STATE_BUCKET_NAME" --policy "$BUCKET_POLICY"

echo "  Bucket configured: s3://$STATE_BUCKET_NAME"
