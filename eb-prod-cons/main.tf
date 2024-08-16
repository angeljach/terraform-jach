#### Lambda Producer Function
resource "aws_lambda_function" "producer" {
  function_name = "producer-function"
  handler       = "producer.lambda_handler"
  runtime       = "python3.9"

  role = aws_iam_role.lambda_exec.arn

  filename = "lambdas/producer.py.zip"
  publish = true
}


#### Lambda Consumer Functions
resource "aws_lambda_function" "consumer1" {
  function_name = "consumer1-function"
  handler       = "consumer1.lambda_handler"
  runtime       = "python3.9"

  role = aws_iam_role.lambda_exec.arn

  filename = "lambdas/consumer1.py.zip"
  publish = true
}

resource "aws_lambda_function" "consumer2" {
  function_name = "consumer2-function"
  handler       = "consumer2.lambda_handler"
  runtime       = "python3.9"

  role = aws_iam_role.lambda_exec.arn

  filename = "lambdas/consumer2.py.zip"
  publish = true
}


### 3. IAM Role for Lambda Functions
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy" {
  name       = "lambda-policy-attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


### 4. Create an EventBridge Event Bus
resource "aws_cloudwatch_event_bus" "event_bus" {
  name = "event-bus"
}


### 5. Create EventBridge Rules to Route Events
#### Rule for Consumer 1
resource "aws_cloudwatch_event_rule" "consumer1_rule" {
  name        = "consumer1-rule"
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
  event_pattern = jsonencode({
    "source" : ["custom.producer"],
    "detail-type" : ["event-for-consumer1"]
  })
}

resource "aws_cloudwatch_event_target" "consumer1_target" {
  target_id = "consumer1-target"
  rule = aws_cloudwatch_event_rule.consumer1_rule.name
  arn  = aws_lambda_function.consumer1.arn
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
}

#### Rule for Consumer 2
resource "aws_cloudwatch_event_rule" "consumer2_rule" {
  name        = "consumer2-rule"
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
  event_pattern = jsonencode({
    "source" : ["custom.producer"],
    "detail-type" : ["event-for-consumer2"]
  })
}

resource "aws_cloudwatch_event_target" "consumer2_target" {
  target_id = "consumer2-target"
  rule = aws_cloudwatch_event_rule.consumer2_rule.name
  arn  = aws_lambda_function.consumer2.arn
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
}


### 6. Grant Permissions for EventBridge to Invoke Lambda

resource "aws_lambda_permission" "allow_eventbridge_consumer1" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.consumer1.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.consumer1_rule.arn
}

resource "aws_lambda_permission" "allow_eventbridge_consumer2" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.consumer2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.consumer2_rule.arn
}

# Update the IAM role lambda_exec to include permissions for the events:PutEvents action on the specified event bus.
resource "aws_iam_role_policy" "lambda_exec_policy" {
  name   = "lambda_exec_policy"
  role   = aws_iam_role.lambda_exec.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "events:PutEvents"
        Resource = aws_cloudwatch_event_bus.event_bus.arn
      }
    ]
  })
}








############## SN
#### Lambda Producer Function
resource "aws_lambda_function" "sn_producer" {
  function_name = "sn_producer-function"
  handler       = "sn_producer.lambda_handler"
  runtime       = "python3.9"

  role = aws_iam_role.lambda_exec.arn

  filename = "lambdas/sn_producer.py.zip"
  publish = true
}


#### Lambda Consumer Functions
resource "aws_lambda_function" "sn_consumer1" {
  function_name = "sn_consumer1-function"
  handler       = "sn_consumer1.lambda_handler"
  runtime       = "python3.9"

  role = aws_iam_role.lambda_exec.arn

  filename = "lambdas/sn_consumer1.py.zip"
  publish = true
}

resource "aws_lambda_function" "sn_consumer2" {
  function_name = "sn_consumer2-function"
  handler       = "sn_consumer2.lambda_handler"
  runtime       = "python3.9"

  role = aws_iam_role.lambda_exec.arn

  filename = "lambdas/sn_consumer2.py.zip"
  publish = true
}

/*
### 5. Create EventBridge Rules to Route Events
#### Rule for Consumer 1
resource "aws_cloudwatch_event_rule" "sn_consumer1_rule" {
  name        = "sn_consumer1-rule"
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
  event_pattern = jsonencode({
    "source" : ["sn.app"],
    "detail-type" : ["transaction"]
  })
}

resource "aws_cloudwatch_event_target" "sn_consumer1_target" {
  target_id = "sn_consumer1-target"
  rule = aws_cloudwatch_event_rule.sn_consumer1_rule.name
  arn  = aws_lambda_function.sn_consumer1.arn
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
}

#### Rule for Consumer 2
resource "aws_cloudwatch_event_rule" "sn_consumer2_rule" {
  name        = "sn-consumer2-rule"
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
  event_pattern = jsonencode({
    "source" : ["sn.app"],
    "detail-type" : ["transaction"]
  })
}

resource "aws_cloudwatch_event_target" "sn_consumer2_target" {
  target_id = "sn-consumer2-target"
  rule = aws_cloudwatch_event_rule.sn_consumer2_rule.name
  arn  = aws_lambda_function.sn_consumer2.arn
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
}
*/

## TODO: UNA REGLA, 2 TARGETS
### 5. Create EventBridge Rules to Route Events
#### Rule for Consumer 1
resource "aws_cloudwatch_event_rule" "sn_consumer_transaction" {
  name        = "sn_consumer-rule"
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
  event_pattern = jsonencode({
    "source" : ["sn.app"],
    "detail-type" : ["transaction"]
  })
}

resource "aws_cloudwatch_event_target" "sn_consumer1_target" {
  target_id = "sn_consumer1-target"
  rule = aws_cloudwatch_event_rule.sn_consumer_transaction.name
  arn  = aws_lambda_function.sn_consumer1.arn
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
}

resource "aws_cloudwatch_event_target" "sn_consumer2_target" {
  target_id = "sn-consumer2-target"
  rule = aws_cloudwatch_event_rule.sn_consumer_transaction.name
  arn  = aws_lambda_function.sn_consumer2.arn
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
}


### 6. Grant Permissions for EventBridge to Invoke Lambda
/*
resource "aws_lambda_permission" "allow_eventbridge_sn_consumer1" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sn_consumer1.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sn_consumer1_rule.arn
}

resource "aws_lambda_permission" "allow_eventbridge_sn_consumer2" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sn_consumer2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sn_consumer2_rule.arn
}
*/
resource "aws_lambda_permission" "allow_eventbridge_sn_consumer1" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sn_consumer1.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sn_consumer_transaction.arn
}

resource "aws_lambda_permission" "allow_eventbridge_sn_consumer2" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sn_consumer2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sn_consumer_transaction.arn
}
