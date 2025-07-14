# 🧠 Task Role (used by your app inside ECS container)
resource "aws_iam_role" "ecs_task_role" {
  name               = var.task_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  description        = "Role used by ECS tasks to access AWS services"

  tags = {
    Purpose = "ECSApp"
  }
}

# 🔐 Task Execution Role (used by ECS agent to pull images, write logs, etc.)
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  description        = "ECS execution role for pulling images, logging, secrets"

  tags = {
    Purpose = "ECSInfra"
  }
}
