provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "project5"
      ManagedBy = "Terraform"
    }
  }
}
