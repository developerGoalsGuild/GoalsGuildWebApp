variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "user_lambda_image_uri" {
  type = string
}

variable "jwt_secret" {
  type = string
}

variable "cognito_callback_urls" {
  type = list(string)
}

variable "google_client_id" {
  type = string
}
variable "google_client_secret" {
  type = string
}
variable "facebook_app_id" {
  type = string
}
variable "facebook_app_secret" {
  type = string
}
variable "apple_client_id" {
  type = string
}
variable "apple_team_id" {
  type = string
}
variable "apple_key_id" {
  type = string
}
variable "apple_private_key" {
  type = string
}
variable "twitter_consumer_key" {
  type = string
}
variable "twitter_consumer_secret" {
  type = string
}
