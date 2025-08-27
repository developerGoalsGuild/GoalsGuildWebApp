/*
  Terraform module to create an AWS ECR repository for GoalsGuild Lambda Docker images.
  */

resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

output "repository_url" {
  description = "URL of the created ECR repository"
  value       = aws_ecr_repository.this.repository_url
}
