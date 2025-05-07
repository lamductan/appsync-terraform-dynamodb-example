# Appsync role

data "aws_iam_policy_document" "iam_appsync_role_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["appsync.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_appsync_role" {
  name               = "${var.prefix}_iam_appsync_role"
  assume_role_policy = data.aws_iam_policy_document.iam_appsync_role_document.json
}

resource "aws_iam_role_policy" "dynamodb_role_policy" {
  name   = "${var.prefix}-dynamodb-role-policy"
  role   = aws_iam_role.iam_appsync_role.id
  policy = data.aws_iam_policy_document.dynamodb_get_policy.json
}

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppSyncPushToCloudWatchLogs"
  role       = aws_iam_role.iam_appsync_role.id
}