# Goals Guild API Documentation

## User Service

### POST /register
Register a new user (email/password).

**Request:**
```json
{
  "email": "user@example.com",
  "password": "hunter2",
  "display_name": "Sir User"
}
```
**Response:** 200 OK  
User profile object.

### POST /login
Login with email/password.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "hunter2"
}
```
**Response:** 200 OK  
JWT and Cognito tokens.

### POST /logout
Logout (JWT required).

### GET /profile
Get user profile (JWT required).

### PUT /profile
Update user profile (JWT required).

### GET /login/social/{provider}
Get Cognito Hosted UI URL for social login.
