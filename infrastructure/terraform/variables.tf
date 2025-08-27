variable "goal_service_dockerFilePath" {
  description = "Path to the DockerFile.lambda for goal-service"
  type        = string
  default     = "./goal-service/DockerFile.lambda"
}

variable "user_lambda_image_uri" {
  description = "URI for user lambda image"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cognito_callback_urls" {
  description = "Cognito callback URLs"
  type        = list(string)
}

# Add other variables as needed
