/**
 * Script to build Docker images from dockerfile.lambda and push to AWS ECR.
 * Supports multiple repositories: user lambda and goals_service.
 * 
 * Usage:
 *   AWS_REGION=us-east-1 ECR_REPOSITORY=goalsguild-user-lambda IMAGE_TAG=latest node scripts/build-and-push-ecr.js
 *   AWS_REGION=us-east-1 ECR_REPOSITORY=goalsguild-goals-service IMAGE_TAG=latest node scripts/build-and-push-ecr.js
 * 
 * Requirements:
 *   - AWS CLI configured with appropriate permissions
 *   - Docker installed and running
 * 
 * This script:
 *   1. Authenticates Docker to AWS ECR
 *   2. Builds the Docker image with the specified tag
 *   3. Pushes the image to the ECR repository
 */

import { execSync } from "child_process";

const AWS_REGION = process.env.AWS_REGION || "us-east-1";
const ECR_REPOSITORY = process.env.ECR_REPOSITORY;
const IMAGE_TAG = process.env.IMAGE_TAG || "latest";

if (!ECR_REPOSITORY) {
  console.error("Error: ECR_REPOSITORY environment variable is required.");
  process.exit(1);
}

async function run() {
  try {
    console.log(`Authenticating Docker to AWS ECR for repository ${ECR_REPOSITORY}...`);
    execSync(
      `aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin $(aws ecr describe-repositories --repository-names ${ECR_REPOSITORY} --region ${AWS_REGION} --query "repositories[0].repositoryUri" --output text)`,
      { stdio: "inherit" }
    );

    const repositoryUri = execSync(
      `aws ecr describe-repositories --repository-names ${ECR_REPOSITORY} --region ${AWS_REGION} --query "repositories[0].repositoryUri" --output text`
    )
      .toString()
      .trim();

    console.log(`Building Docker image ${repositoryUri}:${IMAGE_TAG}...`);
    execSync(
      `docker build -t ${repositoryUri}:${IMAGE_TAG} -f dockerfile.lambda .`,
      { stdio: "inherit" }
    );

    console.log(`Pushing Docker image ${repositoryUri}:${IMAGE_TAG} to ECR...`);
    execSync(`docker push ${repositoryUri}:${IMAGE_TAG}`, { stdio: "inherit" });

    console.log("Docker image build and push completed successfully.");
  } catch (error) {
    console.error("Error during Docker build and push:", error);
    process.exit(1);
  }
}

run();
