import os
import sys
import pytest
from fastapi.testclient import TestClient

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../app')))
from main import app, create_jwt, decode_jwt

client = TestClient(app)

def test_jwt_roundtrip():
    token = create_jwt("user123", "test@example.com")
    payload = decode_jwt(token)
    assert payload["sub"] == "user123"
    assert payload["email"] == "test@example.com"

def test_register_and_login(monkeypatch):
    # Mock Cognito and DynamoDB
    class DummyTable:
        def __init__(self):
            self.items = {}
        def put_item(self, Item):
            self.items[Item["user_id"]] = Item
        def get_item(self, Key):
            return {"Item": self.items.get(Key["user_id"])}
        def scan(self, **kwargs):
            email = kwargs["ExpressionAttributeValues"][":email"]
            for item in self.items.values():
                if item["email"] == email:
                    return {"Items": [item]}
            return {"Items": []}
    monkeypatch.setattr("main.table", DummyTable())

    class DummyCognito:
        def sign_up(self, **kwargs): return {}
        def admin_get_user(self, **kwargs): return {"UserStatus": "CONFIRMED"}
        def admin_confirm_sign_up(self, **kwargs): return {}
        def initiate_auth(self, **kwargs):
            if kwargs["AuthParameters"]["PASSWORD"] == "bad":
                raise Exception("bad password")
            return {"AuthenticationResult": {"IdToken": "id", "RefreshToken": "refresh", "ExpiresIn": 3600}}
        def global_sign_out(self, **kwargs): return {}
    monkeypatch.setattr("main.boto3.client", lambda *a, **k: DummyCognito())

    # Register
    resp = client.post("/register", json={
        "email": "test@example.com",
        "password": "good",
        "display_name": "Sir Test"
    })
    assert resp.status_code == 200
    data = resp.json()
    assert data["email"] == "test@example.com"
    assert data["display_name"] == "Sir Test"

    # Login
    resp = client.post("/login", json={
        "email": "test@example.com",
        "password": "good"
    })
    assert resp.status_code == 200
    tokens = resp.json()
    assert "access_token" in tokens

def test_profile_update(monkeypatch):
    class DummyTable:
        def __init__(self):
            self.items = {}
        def put_item(self, Item):
            self.items[Item["user_id"]] = Item
        def get_item(self, Key):
            return {"Item": self.items.get(Key["user_id"])}
        def scan(self, **kwargs):
            return {"Items": []}
    monkeypatch.setattr("main.table", DummyTable())
    user_id = "user123"
    item = {
        "user_id": user_id,
        "email": "test@example.com",
        "display_name": "Sir Test",
        "created_at": "2024-06-01T00:00:00Z",
        "updated_at": "2024-06-01T00:00:00Z"
    }
    main = sys.modules["main"]
    main.table.put_item(Item=item)
    token = create_jwt(user_id, "test@example.com")
    headers = {"Authorization": f"Bearer {token}"}
    resp = client.put("/profile", json={"display_name": "Sir Knight"}, headers=headers)
    assert resp.status_code == 200
    assert resp.json()["display_name"] == "Sir Knight"
