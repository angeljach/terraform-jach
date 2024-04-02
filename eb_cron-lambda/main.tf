resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_eb_cron"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

/*Rol to write logs on cloudwatch*/
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "schedule-lambda-python.zip"
  function_name = "test_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256("schedule-lambda-python.zip")

  runtime = "python3.9"
  timeout = 10
}

/*Provides an EventBridge Rule resource.*/
resource "aws_cloudwatch_event_rule" "every_2_minutes" {
  name        = "every_2_minutes_rule"
  description = "trigger lambda every 2 minute"

  schedule_expression = "rate(2 minutes)"
}

/*Provides an EventBridge Target resource.*/
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_2_minutes.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.test_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_2_minutes.arn
}
