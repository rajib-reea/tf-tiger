variable "kms_key_id" {
  type        = string
  description = "The KMS key ID to use for state encryption"
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
    profile      = "your-profile"
    region       = "us-east-1"
    bucket       = "infra-tfstate"
    encrypt      = true
    kms_key_id   = "<TO-BE-REPLACED>"  # Filled manually or via templating
    key          = "terraform.tfstate"
  }
}
