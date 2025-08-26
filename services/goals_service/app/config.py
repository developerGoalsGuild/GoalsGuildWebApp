import os

def get_config():
    return {
        "GOALS_TABLE": os.environ.get("GOALS_TABLE", "GoalsGuild_Goals"),
        "AWS_REGION": os.environ.get("AWS_REGION", "us-east-1"),
        "AWS_ACCESS_KEY_ID": os.environ.get("AWS_ACCESS_KEY_ID"),
        "AWS_SECRET_ACCESS_KEY": os.environ.get("AWS_SECRET_ACCESS_KEY"),
    }
