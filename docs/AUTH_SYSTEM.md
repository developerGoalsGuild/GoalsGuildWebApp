# Goals Guild User Registration & Authentication System

## Architecture

- **Backend**: Python FastAPI microservice, AWS Lambda (container), DynamoDB for user profiles, Cognito for authentication (including social logins), JWT for API auth.
- **Infrastructure**: Terraform for Cognito User Pool (with Google, Facebook, Apple, Twitter), DynamoDB, Lambda, API Gateway, Parameter Store.
- **Frontend**: Medieval-themed React app, custom logo, registration/login/profile, Cognito social login, JWT-secured API calls.

## Setup & Deployment

1. **Backend**
   - Build Docker image for user_service.
   - For local: run with `.env` file for config/secrets.
   - For Lambda: build with `Dockerfile.lambda`, push to ECR.

2. **Infrastructure**
   - Set variables in `terraform.tfvars`.
   - Run `terraform init && terraform apply`.

3. **Frontend**
   - `cd frontend && npm install && npm run dev`
   - Update API URLs as needed.

## API Endpoints

- `POST /register` - Register user (email/password)
- `POST /login` - Login (email/password)
- `POST /logout` - Logout
- `GET /profile` - Get user profile (JWT required)
- `PUT /profile` - Update profile (JWT required)
- `GET /login/social/{provider}` - Get Cognito Hosted UI URL for social login

## Security

- All sensitive config/secrets in Parameter Store.
- JWT required for all profile endpoints.
- Cognito handles social login and password security.
