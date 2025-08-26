provider "aws" {
  region = var.aws_region
}

module "goals_table" {
  source = "./modules/dynamodb"
  table_name = var.goals_table_name
  hash_key   = "goal_id"
}

module "tasks_table" {
  source = "./modules/dynamodb"
  table_name = var.tasks_table_name
  hash_key   = "task_id"
}

module "goal_lambda" {
  source = "./modules/lambda"
  function_name = "GoalsGuildGoalService"
  image_uri     = var.goal_lambda_image_uri
  env_vars = {
    GOALS_TABLE = var.goals_table_name
    TASKS_TABLE = var.tasks_table_name
    JWT_SECRET = var.jwt_secret
  }
}
