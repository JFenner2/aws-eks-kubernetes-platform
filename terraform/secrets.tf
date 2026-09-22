data "aws_secretsmanager_secret" "rails_secret_key_base" {
  name = "project5/rails/secret-key-base"
}
