import os
import boto3
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel, Field
from typing import List, Optional
import uuid

# DynamoDB setup
dynamodb = boto3.resource(
    "dynamodb",
    region_name=os.environ.get("AWS_REGION", "us-east-1"),
    aws_access_key_id=os.environ.get("AWS_ACCESS_KEY_ID"),
    aws_secret_access_key=os.environ.get("AWS_SECRET_ACCESS_KEY"),
)
GOALS_TABLE = os.environ.get("GOALS_TABLE", "GoalsGuild_Goals")
table = dynamodb.Table(GOALS_TABLE)

app = FastAPI(title="Goals Guild - Goals Service")

class Task(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    description: str
    due_date: Optional[str] = None
    completed: bool = False

class Goal(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    user_id: str
    title: str
    description: Optional[str] = ""
    tasks: List[Task] = []
    created_at: str
    updated_at: str

@app.post("/goals", response_model=Goal)
def create_goal(goal: Goal):
    item = goal.dict()
    table.put_item(Item=item)
    return goal

@app.get("/goals/{goal_id}", response_model=Goal)
def get_goal(goal_id: str):
    resp = table.get_item(Key={"id": goal_id})
    if "Item" not in resp:
        raise HTTPException(status_code=404, detail="Goal not found")
    return resp["Item"]

@app.get("/goals/user/{user_id}", response_model=List[Goal])
def list_goals(user_id: str):
    resp = table.scan(
        FilterExpression="user_id = :uid",
        ExpressionAttributeValues={":uid": user_id}
    )
    return resp.get("Items", [])

@app.put("/goals/{goal_id}", response_model=Goal)
def update_goal(goal_id: str, goal: Goal):
    item = goal.dict()
    item["id"] = goal_id
    table.put_item(Item=item)
    return item

@app.delete("/goals/{goal_id}")
def delete_goal(goal_id: str):
    table.delete_item(Key={"id": goal_id})
    return {"message": "Goal deleted"}
