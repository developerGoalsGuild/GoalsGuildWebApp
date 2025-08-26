provider "aws" {
  region = var.aws_region
}

module "users_table" {
  source = "./modules/dynamodb"
  table_name = "GoalsGuild_Users"
  hash_key   = "user_id"
}

module "user_lambda" {
  source = "./modules/lambda"
  function_name = "GoalsGuildUserService"
  image_uri     = var.user_lambda_image_uri
  env_vars = {
    USERS_TABLE = module.users_table.table_name
    COGNITO_USER_POOL_ID = module.cognito.user_pool_id
    COGNITO_CLIENT_ID = module.cognito.client_id
    COGNITO_REGION = var.aws_region
    JWT_SECRET = var.jwt_secret
  }
}

module "api_gateway" {
  source = "./modules/apigateway"
  lambda_arn = module.user_lambda.lambda_arn
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
