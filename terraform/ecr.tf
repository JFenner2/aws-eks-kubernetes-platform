resource "aws_ecr_repository" "app" {
  name = "${var.project_name}-app"

  # Production images should not be silently overwritten.
  image_tag_mutability = "IMMUTABLE"

  # Allows Terraform destroy to remove the repository during
  # our disposable development environment, even if images exist.
  force_delete = true

  tags = {
    Name = "${var.project_name}-app"
  }
}
