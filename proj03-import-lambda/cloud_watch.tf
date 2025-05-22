import {
  to = aws_cloudwatch_log_group.lambda_log
  id = "/aws/lambda/manually-created-lambda"
}

resource "aws_cloudwatch_log_group" "lambda_log" {
  name = "/aws/lambda/manually-created-lambda"
}
