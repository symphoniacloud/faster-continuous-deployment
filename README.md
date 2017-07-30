# Faster Continuous Deployment

## Getting started

1. Create a GitHub OAuth token: (https://github.com/settings/tokens)
1. Create Docker image build pipeline CloudFormation stack
1. Create application build pipeline CloudFormation stack

## Teardown

1. Delete application's DynamoDB tables
1. Delete application CloudFormation stack
1. Empty/remove build pipeline S3 buckets via webconsole
1. Delete application build pipeline CloudFormation stack
1. Empty/remove ECR repository
1. Delete image build pipeline CloudFormation stack
