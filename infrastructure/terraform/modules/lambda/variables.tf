variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "image_uri" {
  description = "ECR image URI without tag"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "env_vars" {
  description = "Environment variables map for Lambda"
  type        = map(string)
  default     = {}
}
