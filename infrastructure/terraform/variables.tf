/*
  Core variable definitions for GoalsGuild infrastructure.

  Variables are defined here without environment-specific defaults.
  Environment-specific default values are provided in separate tfvars files:
    - dev.tfvars
    - uat.tfvars
    - prod.tfvars

  This approach promotes modularity and maintainability by separating
  variable declarations from environment-specific values.

  Usage:
    terraform apply -var-file=dev.tfvars
    terraform apply -var-file=uat.tfvars
    terraform apply -var-file=prod.tfvars

  Variables can also be overridden by:
    - Environment variables (TF_VAR_*)
    - Parameter Store or other secret management solutions
*/

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "user_lambda_image_uri" {
  description = "URI of the user lambda Docker image"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret key for GoalsGuild authentication"
  type        = string
  sensitive   = true
}

variable "cognito_callback_urls" {
  description = "List of callback URLs for Cognito"
  type        = list(string)
}

variable "google_client_id" {
  description = "Google OAuth client ID"
  type        = string
  default     = ""
}

variable "google_client_secret" {
  description = "Google OAuth client secret"
  type        = string
  default     = ""
}

variable "facebook_app_id" {
  description = "Facebook App ID"
  type        = string
  default     = ""
}

variable "facebook_app_secret" {
  description = "Facebook App Secret"
  type        = string
  default     = ""
}

variable "apple_client_id" {
  description = "Apple Client ID"
  type        = string
  default     = ""
}

variable "apple_team_id" {
  description = "Apple Team ID"
  type        = string
  default     = ""
}

variable "apple_key_id" {
  description = "Apple Key ID"
  type        = string
  default     = ""
}

variable "apple_private_key" {
  description = "Apple Private Key"
  type        = string
  default     = ""
}

variable "twitter_consumer_key" {
  description = "Twitter Consumer Key"
  type        = string
  default     = ""
}

variable "twitter_consumer_secret" {
  description = "Twitter Consumer Secret"
  type        = string
  default     = ""
}
