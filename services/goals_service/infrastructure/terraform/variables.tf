variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "goal_lambda_image_uri" {
  type = string
}

variable "jwt_secret" {
  type = string
}

variable "goals_table_name" {
  type = string
}

variable "tasks_table_name" {
  type = string
}
