locals {
  default_tags = {
    Environment = "Sandbox"
    ManagedBy   = "Terraform"
    tfstate     = "sre-interview/rajib-pavel.tfstate"
  }
}

provider "aws" {
  profile = "infra-profile"
  region  = "us-east-1"
  default_tags {
    tags = local.default_tags
  }
}

resource "aws_kms_key" "terraform_state" {
  description             = "KMS key for Terraform state encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}

output "kms_key_id" {
  value = aws_kms_key.terraform_state.id
}
