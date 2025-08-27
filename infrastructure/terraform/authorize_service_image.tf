terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "docker" {
  # Use local Docker daemon
  host = "unix:///var/run/docker.sock"
}

# Variable to specify the directory path containing the Dockerfile and build context
variable "dockerFilePath" {
  description = "Path to the directory containing the Dockerfile and build context"
  type        = string
  default     = "./user-service"
}

# Variable to hold AWS region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# ECR repository for authorize-service with force delete, mutable tags, and image scanning on push
resource "aws_ecr_repository" "authorize_service" {
  name                 = "authorize-service"
  force_delete         = true
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "production"
    Project     = "GoalsGuild"
  }
}

# Local file hash to trigger rebuild when Dockerfile or context changes
data "local_file" "user_service_dockerFilePath" {
  filename = "${var.dockerFilePath}/Dockerfile.lambda"
}

data "archive_file" "docker_context" {
  type        = "zip"
  source_dir  = var.dockerFilePath
  output_path = "${path.module}/docker_context.zip"
}

# Local state counter to increment version tag on each apply
resource "local_file" "version_counter" {
  filename = "${path.module}/.version_counter"
  content  = (try(
    tonumber(file("${path.module}/.version_counter")) + 1,
    1
  )) # Increment or start at 1

  # Prevent recreation on every apply by ignoring changes to content if no change
  lifecycle {
    ignore_changes = [content]
  }
}

# Read the current version from the file or default to 1
locals {
  version = try(tonumber(file("${path.module}/.version_counter")), 1)
  image_tag = "v${local.version}"
}

# Build the Docker image locally with the specified build context and Dockerfile path
resource "docker_image" "authorize_service_image" {
  name         = "${aws_ecr_repository.authorize_service.repository_url}:${local.image_tag}"
  build {
    context    = var.user_service_dockerFilePath
    dockerfile = "${var.user_service_dockerFilePath}/Dockerfile.lambda"
  }

  # Rebuild image if Dockerfile or context changes
  keep_locally = false

  # Use triggers to force rebuild on Dockerfile or context changes
  triggers = {
    dockerfile_hash = data.local_file.dockerfile.content_base64
    context_hash    = data.archive_file.docker_context.output_base64sha256
  }
}

# Push the built image to ECR with remote image retention enabled
resource "docker_registry_image" "authorize_service_push" {
  name          = docker_image.authorize_service_image.name
  image_id      = docker_image.authorize_service_image.image_id
  keep_remote   = true

  depends_on = [
    aws_ecr_repository.authorize_service,
    docker_image.authorize_service_image
  ]
}

# Output the full image URI with version tag
output "authorize_service_image_uri" {
  description = "Full image URI including version tag pushed to ECR"
  value       = docker_registry_image.authorize_service_push.name
}

# Output the SHA256 digest of the pushed image
output "authorize_service_image_digest" {
  description = "SHA256 digest of the pushed Docker image"
  value       = docker_registry_image.authorize_service_push.digest
}
