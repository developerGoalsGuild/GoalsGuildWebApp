provider "aws" {
  region = var.aws_region
}

module "ecr_user_lambda" {
  source          = "./modules/ecr"
  repository_name = "goalsguild-user-lambda"
  tags            = {
    Project = "GoalsGuild"
    Env     = var.environment
  }
}

module "ecr_goals_service" {
  source          = "./modules/ecr"
  repository_name = "goalsguild-goals-service"
  tags            = {
    Project = "GoalsGuild"
    Env     = var.environment
  }
}

module "users_table" {
  source = "./modules/dynamodb"
  table_name = "GoalsGuild_Users"
  hash_key   = "user_id"
}

module "goals_table" {
  source = "./modules/dynamodb"
  table_name = "GoalsGuild_Goals"
  hash_key   = "goal_id"
}

module "user_lambda" {
  source = "./modules/lambda"
  function_name = "GoalsGuildUserService"
  image_uri     = module.ecr_user_lambda.repository_url
  image_tag     = var.user_lambda_image_tag
  env_vars = {
    USERS_TABLE = module.users_table.table_name
    COGNITO_USER_POOL_ID = module.cognito.user_pool_id
    COGNITO_CLIENT_ID = module.cognito.client_id
    COGNITO_REGION = var.aws_region
    JWT_SECRET = var.jwt_secret
  }
}

module "goals_lambda" {
  source = "./modules/lambda"
  function_name = "GoalsGuildGoalsService"
  image_uri     = module.ecr_goals_service.repository_url
  image_tag     = var.goals_lambda_image_tag
  env_vars = {
    GOALS_TABLE = module.goals_table.table_name
    COGNITO_USER_POOL_ID = module.cognito.user_pool_id
    COGNITO_CLIENT_ID = module.cognito.client_id
    COGNITO_REGION = var.aws_region
    JWT_SECRET = var.jwt_secret
  }
}

module "api_gateway" {
  source = "./modules/apigateway"
  user_lambda_invoke_arn = module.user_lambda.lambda_arn
  goals_lambda_invoke_arn = module.goals_lambda.lambda_arn
  cognito_user_pool_arn = module.cognito.user_pool_arn
}

module "cognito" {
  source = "./modules/cognito"
  user_pool_name = "GoalsGuildUserPool"
  callback_urls = var.cognito_callback_urls
  google_client_id = var.google_client_id
  google_client_secret = var.google_client_secret
  facebook_app_id = var.facebook_app_id
  facebook_app_secret = var.facebook_app_secret
  apple_client_id = var.apple_client_id
  apple_team_id = var.apple_team_id
  apple_key_id = var.apple_key_id
  apple_private_key = var.apple_private_key
  twitter_consumer_key = var.twitter_consumer_key
  twitter_consumer_secret = var.twitter_consumer_secret
}

module "parameter_store" {
  source              = "./goalsguild_parameter_store"
  cognito_user_pool_id = module.cognito.user_pool_id
  cognito_client_id    = module.cognito.client_id
  users_table_name     = module.users_table.table_name
  jwt_secret           = ""
}

variable "user_lambda_image_tag" {
  description = "Tag for the user lambda Docker image"
  type        = string
  default     = "latest"
}

variable "goals_lambda_image_tag" {
  description = "Tag for the goals_service lambda Docker image"
  type        = string
  default     = "latest"
}

output "user_lambda_image_uri" {
  description = "Full URI of the user lambda Docker image including tag"
  value       = "${module.ecr_user_lambda.repository_url}:${var.user_lambda_image_tag}"
}

output "goals_lambda_image_uri" {
  description = "Full URI of the goals_service lambda Docker image including tag"
  value       = "${module.ecr_goals_service.repository_url}:${var.goals_lambda_image_tag}"
}
