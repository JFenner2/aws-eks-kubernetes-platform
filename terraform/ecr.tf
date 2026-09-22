resource "aws_ecr_repository" "app" {
  name = "${var.project_name}-app"

  # Production images should not be silently overwritten.
  image_tag_mutability = "IMMUTABLE"

  # Automatically scan newly pushed container images for
  # known software vulnerabilities.
  image_scanning_configuration {
    scan_on_push = true
  }

  # Allows Terraform destroy to remove the repository during
  # our disposable development environment, even if images exist.
  force_delete = true

  tags = {
    Name = "${var.project_name}-app"
  }
}
