terraform {
  backend "s3" {
    bucket       = "project5-terraform-state-118178009894"
    key          = "eks-platform/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
