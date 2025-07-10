provider "aws" {
  region              = "us-east-1"
  profile             = "infra-profile"
  allowed_account_ids = ["put-your-id-here"]

  default_tags {
    tags = {
      Environment = "Sandbox"
      ManagedBy   = "Terraform"
      tfstate     = "aws-my-app/terraform.tfstate"
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

  backend "s3" {
    profile      = "infra-profile"
    region       = "us-east-1"
    bucket       = "infra"
    use_lockfile = true
    encrypt      = true
    kms_key_id   = "kms-key-id"
    key          = "aws-my-app/terraform.tfstate"
  }
}
