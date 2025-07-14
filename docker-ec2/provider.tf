provider "aws" {
  region  = "us-east-1"
  profile = "infra-profile"

  default_tags {
    tags = {
      Environment = "Sandbox"
      ManagedBy   = "Terraform"
      tfstate     = "infra/terraform.tfstate"
    }
  }
}

terraform {
  required_version = "~> 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.96.0"
    }
  }

  # backend "local" {}

  backend "s3" {
    profile      = "infra-profile"
    region       = "us-east-1"
    bucket       = "terra-infra-s3"
    use_lockfile = true
    encrypt      = true
    kms_key_id   = "kms_key_id"
    key        = "infra/terraform.tfstate"
  }
}
