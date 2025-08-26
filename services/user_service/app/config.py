import os

def get_config():
    return {
        "COGNITO_USER_POOL_ID": os.environ.get("COGNITO_USER_POOL_ID"),
        "COGNITO_CLIENT_ID": os.environ.get("COGNITO_CLIENT_ID"),
        "COGNITO_REGION": os.environ.get("COGNITO_REGION", "us-east-1"),
        "USERS_TABLE": os.environ.get("USERS_TABLE", "GoalsGuild_Users"),
        "JWT_SECRET": os.environ.get("JWT_SECRET", "dev_secret"),
        "AWS_ACCESS_KEY_ID": os.environ.get("AWS_ACCESS_KEY_ID"),
        "AWS_SECRET_ACCESS_KEY": os.environ.get("AWS_SECRET_ACCESS_KEY"),
    }
