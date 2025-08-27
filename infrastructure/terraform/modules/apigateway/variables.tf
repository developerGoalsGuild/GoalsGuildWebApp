variable "user_lambda_invoke_arn" {
  description = "ARN of the user Lambda function to integrate"
  type        = string
}

variable "goals_lambda_invoke_arn" {
  description = "ARN of the goals_service Lambda function to integrate"
  type        = string
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito user pool for authorization"
  type        = string
}
