import os
import sys
import pytest
from fastapi.testclient import TestClient

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../app')))
from main import app, Goal, Task

client = TestClient(app)

def test_create_and_get_goal(monkeypatch):
    # Mock DynamoDB table
    class DummyTable:
        def __init__(self):
            self.items = {}
        def put_item(self, Item):
            self.items[Item["id"]] = Item
        def get_item(self, Key):
            return {"Item": self.items.get(Key["id"])}
        def scan(self, **kwargs):
            return {"Items": list(self.items.values())}
        def delete_item(self, Key):
            self.items.pop(Key["id"], None)
    monkeypatch.setattr("main.table", DummyTable())

    goal = {
        "user_id": "user123",
        "title": "Test Goal",
        "description": "A test goal",
        "tasks": [],
        "created_at": "2024-06-01T00:00:00Z",
        "updated_at": "2024-06-01T00:00:00Z"
    }
    response = client.post("/goals", json=goal)
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Test Goal"

    goal_id = data["id"]
    response = client.get(f"/goals/{goal_id}")
    assert response.status_code == 200
    assert response.json()["id"] == goal_id

    response = client.get(f"/goals/user/{goal['user_id']}")
    assert response.status_code == 200
    assert len(response.json()) == 1

    response = client.delete(f"/goals/{goal_id}")
    assert response.status_code == 200
