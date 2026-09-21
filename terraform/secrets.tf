resource "aws_secretsmanager_secret" "rails_secret_key_base" {
  name        = "project5/rails/secret-key-base"
  description = "Rails SECRET_KEY_BASE for Project 5 EKS application"

  tags = {
    Name = "project5-rails-secret-key-base"
  }
}
