variable "app_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "secret_name" {
  description = "Prefix of the secret in AWS Secrets Manager"
  type        = string
  default     = ""
}
