#!/bin/bash

set -e

function physical_resource_id() {
  # Return (w/ retcode 2) if no args
  [[ $# -eq 0 ]] && return 2

  local stack_name="$1"
  local logical_resource_id="$2"

  result=$(aws cloudformation list-stack-resources \
    --stack-name ${stack_name} \
    --query "StackResourceSummaries[?LogicalResourceId==\`${logical_resource_id}\`].PhysicalResourceId" \
    --output text)

  echo $result
}

# Delete application stack
# 1. Remove DynamoDB table

DYNAMODB_TABLE=$(aws cloudformation list-stack-resources --stack-name serverless-app --query 'StackResourceSummaries[?LogicalResourceId==`Table`].PhysicalResourceId' --output text)

echo "Deleting DynamoDB table [${DYNAMODB_TABLE}]"

aws dynamodb delete-table --table-name ${DYNAMODB_TABLE}

# 2. Issue CloudFormation delete-stack command

aws cloudformation delete-stack --stack-name serverless-app

# Delete build stack
# 1. Remove S3 buckets (x3)

# 1.1 Delete artifact bucket

S3_ARTIFACT_BUCKET=$(aws cloudformation list-stack-resources --stack-name serverless-build-pipeline --query 'StackResourceSummaries[?LogicalResourceId==`ArtifactBucket`].PhysicalResourceId' --output text)

echo "Emptying S3 bucket [${S3_ARTIFACT_BUCKET}]"

aws s3api put-bucket-lifecycle --bucket ${S3_ARTIFACT_BUCKET} --lifecycle-configuration '{"Rules":[{"Status":"Enabled","Prefix":"","Expiration":{"Date":0}}]}'

echo "Deleting S3 bucket [${S3_ARTIFACT_BUCKET}]"

aws s3api delete-bucket --bucket ${S3_ARTIFACT_BUCKET}

S3_CLOUDFORMATION_BUCKET=$(aws cloudformation list-stack-resources --stack-name serverless-build-pipeline --query 'StackResourceSummaries[?LogicalResourceId==`CfnBucket`].PhysicalResourceId' --output text)

echo "Emptying S3 bucket [${S3_CLOUDFORMATION_BUCKET}]"

aws s3api put-bucket-lifecycle --bucket ${S3_CLOUDFORMATION_BUCKET} --lifecycle-configuration '{"Rules":[{"Status":"Enabled","Prefix":"","Expiration":{"Date":0}}]}'

echo "Deleting S3 bucket [${S3_CLOUDFORMATION_BUCKET}]"

aws s3api delete-bucket --bucket ${S3_CLOUDFORMATION_BUCKET}

# 2. Issue CloudFormation delete-stack command

aws cloudformation delete-stack --stack-name serverless-app-build-pipeline

# Delete image build stack

# 1. Remove ECR repository

ECR_REPOSITORY_NAME=$(aws cloudformation list-stack-resources --stack-name serverless-app-image-pipeline --query 'StackResourceSummaries[?LogicalResourceId==`ImageRepository`].PhysicalResourceId' --output text)

aws ecr delete-repository --force --repository-name ${ECR_REPOSITORY_NAME}

aws cloudformation delete-stack --stack-name serverless-app-image-pipeline
