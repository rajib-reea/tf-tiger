variable "app_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "secret_name" {
  description = "Prefix of the secret in AWS Secrets Manager"
  type        = string
  default     = ""
}

variable "app_port" {
  type        = number
  description = "Port the application listens on"
}

variable "alb_port" {
  type        = number
  description = "Port the application listens on"
}

variable "all_port" {
  type        = number
  description = "Port that has no restriction"
}

