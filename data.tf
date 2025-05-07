data "aws_iam_policy_document" "dynamodb_get_policy" {
  statement {
    actions = [
      "dynamodb:*"
    ]

    resources = [
      "*",
    ]
  }
}