# GoalsGuild Infrastructure Automation

## Docker Image Build and Push Automation

The `scripts/build-and-push-ecr.js` script automates building Docker images from `dockerfile.lambda` and pushing them to AWS ECR repositories.

### Supported Repositories

- `goalsguild-user-lambda`
- `goalsguild-goals-service`

### Prerequisites

- AWS CLI configured with credentials and permissions to access ECR.
- Docker installed and running.
- Node.js installed to run the script.

### Usage

Set environment variables as needed (example for user lambda):

```bash
export AWS_REGION=us-east-1
export ECR_REPOSITORY=goalsguild-user-lambda
export IMAGE_TAG=latest
node scripts/build-and-push-ecr.js
```

For goals_service lambda:

```bash
export AWS_REGION=us-east-1
export ECR_REPOSITORY=goalsguild-goals-service
export IMAGE_TAG=latest
node scripts/build-and-push-ecr.js
```

### Terraform Integration

- The ECR repositories are provisioned via the Terraform module `modules/ecr`.
- The Lambda functions are configured to use the Docker image URIs with the specified tags.
- The API Gateway module integrates the Lambda functions with POST methods secured by Cognito.

### Notes

- Ensure the ECR repositories exist before running the build script.
- The image tags can be customized per environment.
- The Terraform `main.tf` outputs the full image URIs for use in other modules.

## Extending API Gateway

The API Gateway Terraform module includes POST methods for both user and goals_service Lambda functions with Cognito authorization.
