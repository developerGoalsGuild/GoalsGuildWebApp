# Goals Guild Phase 1 Infrastructure

## Overview

This document describes the Terraform-based infrastructure for Phase 1.

## Resources

- **DynamoDB**: Table for goals.
- **Lambda**: Container-based function for goals service.
- **API Gateway**: REST API with Cognito authorizer.
- **Cognito**: User pool for authentication.

## Usage

1. Set variables in `terraform.tfvars`.
2. Run:
   ```
   terraform init
   terraform apply
   ```

## Notes

- Lambda image must be built and pushed to ECR before applying.
- API Gateway is configured to require Cognito authentication.
