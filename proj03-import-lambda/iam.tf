import {
  to = aws_iam_role.lambda_execution_role
  id = "manually-created-lambda-role-5zoifq1k"
}
import {
  to = aws_iam_policy.lambda_execution
  id = "arn:aws:iam::998062551480:policy/service-role/AWSLambdaBasicExecutionRole-85287a81-8f5f-4fb6-9829-05daed36b6f2"
}


resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_execution_role.json
  name               = "manually-created-lambda-role-5zoifq1k"
  path               = "/service-role/"
}

resource "aws_iam_policy" "lambda_execution" {
  name   = "AWSLambdaBasicExecutionRole-85287a81-8f5f-4fb6-9829-05daed36b6f2"
  path   = "/service-role/"
  policy = data.aws_iam_policy_document.lambda_execution.json
}
resource "aws_iam_role_policy_attachment" "assume_lambda_execution_policy" {
  policy_arn = aws_iam_policy.lambda_execution.arn
  role       = aws_iam_role.lambda_execution_role.name
}

data "aws_caller_identity" "current" {}


data "aws_region" "current" {}


data "aws_iam_policy_document" "assume_lambda_execution_role" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_execution" {
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
    ]
    actions = ["logs:CreateLogGroup"]
  }
  statement {
    effect = "Allow"
    resources = [
      "${aws_cloudwatch_log_group.lambda_log.arn}:*",
    ]
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]
  }
}