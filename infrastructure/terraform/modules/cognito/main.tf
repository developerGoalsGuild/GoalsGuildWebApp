resource "aws_cognito_user_pool" "this" {
  name = var.user_pool_name
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.user_pool_name}-client"
  user_pool_id = aws_cognito_user_pool.this.id
  generate_secret = false
  callback_urls   = var.callback_urls
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers = [
    "COGNITO",
    "Google",
    "Facebook",
    "Apple",
    "Twitter"
  ]
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Google"
  provider_type = "Google"
  provider_details = {
    client_id     = var.google_client_id
    client_secret = var.google_client_secret
    authorize_scopes = "openid email profile"
  }
  attribute_mapping = {
    email = "email"
    username = "sub"
  }
}

resource "aws_cognito_identity_provider" "facebook" {
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Facebook"
  provider_type = "Facebook"
  provider_details = {
    client_id     = var.facebook_app_id
    client_secret = var.facebook_app_secret
    authorize_scopes = "email public_profile"
  }
  attribute_mapping = {
    email = "email"
    username = "id"
  }
}

resource "aws_cognito_identity_provider" "apple" {
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Apple"
  provider_type = "Apple"
  provider_details = {
    client_id     = var.apple_client_id
    team_id       = var.apple_team_id
    key_id        = var.apple_key_id
    private_key   = var.apple_private_key
    authorize_scopes = "email name"
  }
  attribute_mapping = {
    email = "email"
    username = "sub"
  }
}

resource "aws_cognito_identity_provider" "twitter" {
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Twitter"
  provider_type = "Twitter"
  provider_details = {
    client_id     = var.twitter_consumer_key
    client_secret = var.twitter_consumer_secret
    authorize_scopes = "email"
  }
  attribute_mapping = {
    email = "email"
    username = "id"
  }
}

output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}
output "user_pool_arn" {
  value = aws_cognito_user_pool.this.arn
}
output "client_id" {
  value = aws_cognito_user_pool_client.client.id
}
