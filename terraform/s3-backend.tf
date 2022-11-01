# We add in the backend configuration
  terraform {
    backend "s3" {
    bucket                  = "cloudsheger-development-terraform"
    key                     = "cloudsheger/terraform.tfstate"
    dynamodb_table          = "cloudsheger-development-terraform"
    region                  = "us-east-1"
  }
  }
  