# 🔍 Get AWS account ID and region dynamically
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ✅ Local conditional secrets policy
locals {
  secret_statement = length(trimspace(var.secret_name)) > 0 ? [{
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.secret_name}-*"
    ]
  }] : []
}

# 📄 Combined IAM policy document
data "aws_iam_policy_document" "app_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.app_bucket_name}/*"
    ]
  }

  dynamic "statement" {
    for_each = local.secret_statement
    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

