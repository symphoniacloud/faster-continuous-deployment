# Faster Continuous Deployment

For an article about the concepts in this repository, please see https://read.acloud.guru/3-pro-tips-to-speed-up-your-java-based-aws-lambda-continuous-deployment-builds-72310fe18274

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
