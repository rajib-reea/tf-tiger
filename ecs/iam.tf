# 👥 Trust relationship document shared by both roles
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

# 📦 Attach AWS-managed execution policy to allow logging, pulling images, etc.
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 📦 Example: Attach a custom app policy to ecs_task_role (optional)
resource "aws_iam_policy" "app_access_policy" {
  name        = "ecsAppAccessPolicy"
  description = "Allow access to specific AWS resources from ECS task"

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
        Resource = "arn:aws:secretsmanager:your-region:your-account-id:secret:your-secret-name-*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_app_policy_attach" {
  name       = "AttachAppAccessPolicy"
  policy_arn = aws_iam_policy.app_access_policy.arn
  roles      = [aws_iam_role.ecs_task_role.name]
}
