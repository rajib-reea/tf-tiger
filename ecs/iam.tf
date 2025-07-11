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
