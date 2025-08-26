resource "aws_ssm_parameter" "jwt_secret" {
  name  = "/goalsguild/jwt_secret"
  type  = "SecureString"
  value = var.jwt_secret
}

resource "aws_ssm_parameter" "goals_table" {
  name  = "/goalsguild/goals_table"
  type  = "String"
  value = var.goals_table_name
}

resource "aws_ssm_parameter" "tasks_table" {
  name  = "/goalsguild/tasks_table"
  type  = "String"
  value = var.tasks_table_name
}
