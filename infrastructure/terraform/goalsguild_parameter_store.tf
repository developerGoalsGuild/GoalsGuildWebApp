/*
  Terraform module for AWS Systems Manager Parameter Store parameters
  strictly scoped under the "goalsguild" domain.

  This updated script supports assigning variable values from outputs
  of other infrastructure modules or scripts to promote modularity,
  reusability, and proper dependency management.

  Usage:
    - Pass output values from other Terraform modules or root module
      outputs into the variables defined here.
    - Example:
        module "cognito" {
          source = "../cognito"
          ...
        }

        module "parameter_store" {
          source              = "./goalsguild_parameter_store"
          cognito_user_pool_id = module.cognito.user_pool_id
          cognito_client_id    = module.cognito.client_id
          users_table_name     = module.dynamodb.users_table_name
          jwt_secret           = var.jwt_secret  # Can be passed from root or secrets manager
        }

  Variables:
    - jwt_secret: Sensitive secret string (e.g., JWT signing key)
    - cognito_user_pool_id: Output from Cognito module
    - cognito_client_id: Output from Cognito module
    - users_table_name: Output from DynamoDB module

  Notes:
    - Ensure that the modules providing outputs are declared and applied before this module.
    - This module does not create those resources; it only stores their identifiers/secrets in Parameter Store.
    - Keep all parameter names prefixed with "/goalsguild/" for domain scoping.
*/

variable "jwt_secret" {
  description = "JWT secret key for GoalsGuild authentication. Pass from secrets manager or root module."
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID for GoalsGuild. Pass output from Cognito module."
  type        = string
}

variable "cognito_client_id" {
  description = "Cognito App Client ID for GoalsGuild. Pass output from Cognito module."
  type        = string
}

variable "users_table_name" {
  description = "DynamoDB Users table name for GoalsGuild. Pass output from DynamoDB module."
  type        = string
}

resource "aws_ssm_parameter" "jwt_secret" {
  name        = "/goalsguild/jwt_secret"
  description = "JWT secret key for GoalsGuild authentication"
  type        = "SecureString"
  value       = var.jwt_secret
  tags = {
    Domain      = "goalsguild"
    Environment = terraform.workspace
  }
}

resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name        = "/goalsguild/cognito_user_pool_id"
  description = "Cognito User Pool ID for GoalsGuild"
  type        = "String"
  value       = var.cognito_user_pool_id
  tags = {
    Domain      = "goalsguild"
    Environment = terraform.workspace
  }
}

resource "aws_ssm_parameter" "cognito_client_id" {
  name        = "/goalsguild/cognito_client_id"
  description = "Cognito App Client ID for GoalsGuild"
  type        = "String"
  value       = var.cognito_client_id
  tags = {
    Domain      = "goalsguild"
    Environment = terraform.workspace
  }
}

resource "aws_ssm_parameter" "users_table" {
  name        = "/goalsguild/users_table"
  description = "DynamoDB Users table name for GoalsGuild"
  type        = "String"
  value       = var.users_table_name
  tags = {
    Domain      = "goalsguild"
    Environment = terraform.workspace
  }
}

/*
  Example IAM policy snippet to restrict access to parameters
  within the /goalsguild/ namespace. Attach this policy to roles
  or users that require access to these parameters.

  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParameterHistory"
        ],
        "Resource": "arn:aws:ssm:${aws_region}:${aws_account_id}:parameter/goalsguild/*"
      }
    ]
  }
*/
