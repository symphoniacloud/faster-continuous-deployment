#!/bin/bash

set -e

[[ $# -eq 0 ]] && exit 2

APPLICATION_STACK_NAME="serverless-app"

aws cloudformation update-stack \
  --stack-name "${APPLICATION_STACK_NAME}-image-build" \
  --capabilities CAPABILITY_IAM  \
  --template-body file://infrastructure/image-cfn.yml \
  --parameters ParameterKey=GitHubToken,ParameterValue=${1} \
               ParameterKey=GitHubUser,ParameterValue=symphoniacloud \
               ParameterKey=GitHubRepository,ParameterValue=faster-continuous-deployment

aws cloudformation wait stack-update-complete \
  --stack-name ${APPLICATION_STACK_NAME}-image-build

CODE_BUILD_IMAGE=$(aws cloudformation list-exports \
  --query "Exports[?Name==\`ServerlessAppBuildImage\`].Value" \
  --output text)

aws cloudformation update-stack \
  --stack-name "${APPLICATION_STACK_NAME}-build" \
  --capabilities CAPABILITY_IAM  \
  --template-body file://infrastructure/build-cfn.yml \
  --parameters ParameterKey=GitHubToken,ParameterValue=${1} \
               ParameterKey=GitHubUser,ParameterValue=symphoniacloud \
               ParameterKey=GitHubRepository,ParameterValue=faster-continuous-deployment \
               ParameterKey=CodeBuildImage,ParameterValue=${CODE_BUILD_IMAGE}
