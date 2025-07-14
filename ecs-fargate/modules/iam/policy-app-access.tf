# 🔐 Custom IAM policy allowing access to a specific secret and S3
resource "aws_iam_policy" "app_access_policy" {
  name        = var.app_access_policy
  description = "Allow access to S3 and Secrets Manager"

  policy = data.aws_iam_policy_document.app_access.json
}

# 🔗 Attach the custom policy to the app (task) role
resource "aws_iam_policy_attachment" "ecs_app_policy_attach" {
  name       = var.app_policy_attach
  roles      = [aws_iam_role.ecs_task_role.name]
  policy_arn = aws_iam_policy.app_access_policy.arn
}
