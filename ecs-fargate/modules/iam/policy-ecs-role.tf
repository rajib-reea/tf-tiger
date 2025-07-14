# 📄 Reference the AWS managed ECS execution role policy
data "aws_iam_policy" "ecs_execution_managed" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 📎 Attach AWS-managed execution policy for ECS agent
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_execution_managed.arn
}