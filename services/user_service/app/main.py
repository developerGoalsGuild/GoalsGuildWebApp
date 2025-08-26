import os
import boto3
import uuid
import jwt
import requests
from fastapi import FastAPI, HTTPException, Depends, Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel, EmailStr, Field
from typing import Optional, Dict, Any
from datetime import datetime, timedelta

# Config
COGNITO_USER_POOL_ID = os.environ.get("COGNITO_USER_POOL_ID")
COGNITO_CLIENT_ID = os.environ.get("COGNITO_CLIENT_ID")
COGNITO_REGION = os.environ.get("COGNITO_REGION", "us-east-1")
USERS_TABLE = os.environ.get("USERS_TABLE", "GoalsGuild_Users")
JWT_SECRET = os.environ.get("JWT_SECRET", "dev_secret")
JWT_ALGORITHM = "HS256"
JWT_EXP_MINUTES = 60

dynamodb = boto3.resource(
    "dynamodb",
    region_name=COGNITO_REGION,
    aws_access_key_id=os.environ.get("AWS_ACCESS_KEY_ID"),
    aws_secret_access_key=os.environ.get("AWS_SECRET_ACCESS_KEY"),
)
table = dynamodb.Table(USERS_TABLE)

app = FastAPI(title="Goals Guild - User Service")
security = HTTPBearer()

# Models
class UserRegister(BaseModel):
    email: EmailStr
    password: str
    display_name: Optional[str] = ""

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserProfile(BaseModel):
    user_id: str
    email: EmailStr
    display_name: Optional[str] = ""
    created_at: str
    updated_at: str

class UserProfileUpdate(BaseModel):
    display_name: Optional[str] = ""

# Helper: JWT
def create_jwt(user_id: str, email: str) -> str:
    payload = {
        "sub": user_id,
        "email": email,
        "exp": datetime.utcnow() + timedelta(minutes=JWT_EXP_MINUTES)
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)

def decode_jwt(token: str) -> Dict[str, Any]:
    try:
        return jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid or expired token")

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    payload = decode_jwt(credentials.credentials)
    user_id = payload.get("sub")
    email = payload.get("email")
    if not user_id or not email:
        raise HTTPException(status_code=401, detail="Invalid token payload")
    return {"user_id": user_id, "email": email}

# Helper: Cognito
def cognito_signup(email, password):
    client = boto3.client("cognito-idp", region_name=COGNITO_REGION)
    try:
        resp = client.sign_up(
            ClientId=COGNITO_CLIENT_ID,
            Username=email,
            Password=password,
            UserAttributes=[{"Name": "email", "Value": email}],
        )
        return resp
    except client.exceptions.UsernameExistsException:
        raise HTTPException(status_code=400, detail="User already exists")
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

def cognito_confirm(email):
    # For demo: auto-confirm user (in prod, use email confirmation)
    client = boto3.client("cognito-idp", region_name=COGNITO_REGION)
    user = client.admin_get_user(
        UserPoolId=COGNITO_USER_POOL_ID,
        Username=email
    )
    if user["UserStatus"] != "CONFIRMED":
        client.admin_confirm_sign_up(
            UserPoolId=COGNITO_USER_POOL_ID,
            Username=email
        )

def cognito_login(email, password):
    client = boto3.client("cognito-idp", region_name=COGNITO_REGION)
    try:
        resp = client.initiate_auth(
            ClientId=COGNITO_CLIENT_ID,
            AuthFlow="USER_PASSWORD_AUTH",
            AuthParameters={"USERNAME": email, "PASSWORD": password},
        )
        return resp["AuthenticationResult"]
    except client.exceptions.NotAuthorizedException:
        raise HTTPException(status_code=401, detail="Incorrect username or password")
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

# API: Registration
@app.post("/register", response_model=UserProfile)
def register(user: UserRegister):
    cognito_signup(user.email, user.password)
    cognito_confirm(user.email)
    user_id = str(uuid.uuid4())
    now = datetime.utcnow().isoformat()
    item = {
        "user_id": user_id,
        "email": user.email,
        "display_name": user.display_name or "",
        "created_at": now,
        "updated_at": now,
    }
    table.put_item(Item=item)
    return UserProfile(**item)

# API: Login
@app.post("/login")
def login(user: UserLogin):
    auth_result = cognito_login(user.email, user.password)
    # Find user_id from DynamoDB
    resp = table.scan(
        FilterExpression="email = :email",
        ExpressionAttributeValues={":email": user.email}
    )
    items = resp.get("Items", [])
    if not items:
        raise HTTPException(status_code=404, detail="User profile not found")
    user_id = items[0]["user_id"]
    jwt_token = create_jwt(user_id, user.email)
    return {
        "access_token": jwt_token,
        "id_token": auth_result.get("IdToken"),
        "refresh_token": auth_result.get("RefreshToken"),
        "expires_in": auth_result.get("ExpiresIn"),
        "token_type": "Bearer"
    }

# API: Logout (Cognito global signout)
@app.post("/logout")
def logout(current=Depends(get_current_user)):
    client = boto3.client("cognito-idp", region_name=COGNITO_REGION)
    try:
        client.global_sign_out(
            AccessToken=current.get("access_token", "")
        )
    except Exception:
        pass
    return {"message": "Logged out"}

# API: Get Profile
@app.get("/profile", response_model=UserProfile)
def get_profile(current=Depends(get_current_user)):
    resp = table.get_item(Key={"user_id": current["user_id"]})
    if "Item" not in resp:
        raise HTTPException(status_code=404, detail="Profile not found")
    return UserProfile(**resp["Item"])

# API: Update Profile
@app.put("/profile", response_model=UserProfile)
def update_profile(update: UserProfileUpdate, current=Depends(get_current_user)):
    resp = table.get_item(Key={"user_id": current["user_id"]})
    if "Item" not in resp:
        raise HTTPException(status_code=404, detail="Profile not found")
    item = resp["Item"]
    if update.display_name is not None:
        item["display_name"] = update.display_name
    item["updated_at"] = datetime.utcnow().isoformat()
    table.put_item(Item=item)
    return UserProfile(**item)

# API: Social login (redirect to Cognito Hosted UI)
@app.get("/login/social/{provider}")
def social_login(provider: str):
    # provider: 'Google', 'Facebook', 'Apple', 'Twitter'
    base_url = f"https://{COGNITO_DOMAIN}/oauth2/authorize"
    redirect_uri = os.environ.get("COGNITO_REDIRECT_URI")
    client_id = COGNITO_CLIENT_ID
    scope = "openid+profile+email"
    response_type = "code"
    url = (
        f"{base_url}?identity_provider={provider}"
        f"&redirect_uri={redirect_uri}"
        f"&response_type={response_type}"
        f"&client_id={client_id}"
        f"&scope={scope}"
    )
    return {"url": url}
