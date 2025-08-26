# Local development Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY app/ ./app/
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Optional: Copy .env file for local development (if present)
# ENV variables can also be set via docker run -e or docker-compose
# Example .env file:
# GOALS_TABLE=GoalsGuild_Goals
# TASKS_TABLE=GoalsGuild_Tasks
# JWT_SECRET=dev_secret
# AWS_ACCESS_KEY_ID=...
# AWS_SECRET_ACCESS_KEY=...
# (AWS credentials are only needed for local/dev, not managed by Terraform)

ENV PYTHONPATH=/app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
