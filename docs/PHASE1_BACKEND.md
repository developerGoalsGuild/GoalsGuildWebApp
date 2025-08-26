# Goals Guild Phase 1 Backend

## Overview

This document describes the backend microservice architecture, local development, deployment, and testing for Phase 1.

## Microservice Structure

- Each service is a Python FastAPI app, containerized for Lambda.
- DynamoDB is used for persistent storage.
- Configuration and secrets are injected via environment variables (from AWS Parameter Store in prod, `.env` for local).

## Local Development

1. Copy `.env.example` to `.env` and fill in values.
2. Build and run the service:
   ```
   docker build -t goals-service -f Dockerfile .
   docker run --env-file .env -p 8080:8080 goals-service
   ```
3. Run tests:
   ```
   pip install -r requirements.txt
   pytest tests/
   ```

## Deployment

- Build the Lambda image with `Dockerfile.lambda` and push to ECR.
- Use Terraform to deploy infrastructure.

## API Endpoints

- `POST /goals` - Create a goal
- `GET /goals/{goal_id}` - Get a goal
- `GET /goals/user/{user_id}` - List user's goals
- `PUT /goals/{goal_id}` - Update a goal
- `DELETE /goals/{goal_id}` - Delete a goal

## Security

- All endpoints are protected by Cognito authorizer via API Gateway.
