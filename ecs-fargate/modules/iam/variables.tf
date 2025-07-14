variable "app_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "terra-infra-s3"
}

variable "secret_name" {
  description = "Prefix of the secret in AWS Secrets Manager"
  type        = string
  default     = ""
}

# variable "name_prefix" {
#   type        = string
#   description = "Prefix for naming IAM roles and policies"
#   default     = "hello-world"
# }

variable "task_role_name" {
  type        = string
  description = "Name for ECS task role"
  default     = "ecsTaskRole"
}

variable "task_execution_role_name" {
  type        = string
  description = "Name for ECS task execution role"
  default     = "ecsTaskExecutionRole"
}

variable app_access_policy {
  type        = string
  description = "Name for ECS app access policy"
  default     = "ecsAppAccessPolicy"
}
variable app_policy_attach {
  type        = string
  description = "Name for ECS app access policy attachment"
  default     = "ecsAttachAppAccessPolicy"
}


variable "logging" {
  type        = string
  description = "Name for ECS logging"
  default     = "ecsLoggingPolicy"
}
