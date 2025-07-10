# 🔍 Get AWS account ID and region dynamically
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# 📦 Input variable for your secret name prefix
variable "secret_name" {
  description = "Prefix of the secret in AWS Secrets Manager"
  type        = string
}

# 👥 Trust relationship document shared by both ECS roles
data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# 🧠 Task Role (used by your app inside ECS container)
resource "aws_iam_role" "ecs_task_role" {
  name               = "ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  description        = "Role used by ECS tasks to access AWS services"

  tags = {
    Purpose = "ECSApp"
  }
}

# 🔐 Task Execution Role (used by ECS agent to pull images, write logs, etc.)
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  description        = "ECS execution role for pulling images, logging, secrets"

  tags = {
    Purpose = "ECSInfra"
  }
}

# 📎 Attach AWS-managed execution policy for ECS agent
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 🔐 Custom IAM policy allowing access to a specific secret and S3
resource "aws_iam_policy" "app_access_policy" {
  name        = "ecsAppAccessPolicy"
  description = "Allow access to S3 and a dynamic Secrets Manager secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::your-app-bucket/*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.secret_name}-*"
      }
    ]
  })
}

# 🔗 Attach the custom policy to the app (task) role
resource "aws_iam_policy_attachment" "ecs_app_policy_attach" {
  name       = "AttachAppAccessPolicy"
  policy_arn = aws_iam_policy.app_access_policy.arn
  roles      = [aws_iam_role.ecs_task_role.name]
}
