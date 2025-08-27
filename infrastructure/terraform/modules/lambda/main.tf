/*
  Lambda module updated to support container image deployment.
  */

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  package_type  = "Image"
  image_uri     = "${var.image_uri}:${var.image_tag}"
  role          = aws_iam_role.lambda_exec.arn

  environment {
    variables = var.env_vars
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}-lambda-exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}
