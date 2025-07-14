resource "aws_iam_policy" "ecs_logging" {
  name   = var.logging
  policy = data.aws_iam_policy_document.ecs_task_execution_logging.json
}

resource "aws_iam_role_policy_attachment" "ecs_logging_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_logging.arn
}
