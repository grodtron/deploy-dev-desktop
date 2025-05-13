terraform {
  backend "s3" {
    bucket         = "grodtron-terraform"
    key            = "deploy-dev-desktop/terraform.tfstate"
    region         = "eu-north-1"
    use_lockfile   = true
    encrypt        = true
  }
}
