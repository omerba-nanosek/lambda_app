locals {
  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Action": "sts:AssumeRole",
"Principal": {
"Service": "lambda.amazonaws.com"
},
"Effect": "Allow",
"Sid": ""
}
]
}
EOF
}

resource "aws_iam_role" "lambda-role" {
  name = "lambda-role"
  assume_role_policy = local.policy
}

resource "aws_lambda_function" "my-func" {
  function_name = var.name
  role          = aws_iam_role.lambda-role.arn
  s3_bucket     = var.bucket
  s3_key        = var.key
  runtime = "python3.8"
  handler = "app.handler"
  memory_size = 128
}

resource "aws_cloudwatch_event_rule" "ten-min" {
  name = "ten-min"
  schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "ten-min-target" {
  arn  = aws_lambda_function.my-func.arn
  rule = aws_cloudwatch_event_rule.ten-min.name
}

resource "aws_lambda_permission" "allow-lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my-func.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ten-min.arn
}