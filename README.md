# urbanpetr.com

## What is this?
- Website urbanpetr.com
- Terraform for the website

## Prerequisites
- have an AWS account and aws cli running
  - AWS user allowing terraform via github (ie. `terraform-github`)
- for github integration
    - have a DynamoDB table for terraform state locking
    - have S3 bucket for terraform state

## Live Deployment
- when PR is merged then website is deployed live / updated live via github actions