resource "aws_ssm_parameter" "jwt_secret" {
  name  = "/goalsguild/jwt_secret"
  type  = "SecureString"
  value = var.jwt_secret
}

resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name  = "/goalsguild/cognito_user_pool_id"
  type  = "String"
  value = module.cognito.user_pool_id
}

resource "aws_ssm_parameter" "cognito_client_id" {
  name  = "/goalsguild/cognito_client_id"
  type  = "String"
  value = module.cognito.client_id
}

resource "aws_ssm_parameter" "cognito_region" {
  name  = "/goalsguild/cognito_region"
  type  = "String"
  value = var.aws_region
}

resource "aws_ssm_parameter" "users_table" {
  name  = "/goalsguild/users_table"
  type  = "String"
  value = module.users_table.table_name
}
