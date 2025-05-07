# Common tags for all resources
locals {
  common_tags = {
    env                   = "sb"
    business_unit         = "TRV"
    monitoring            = "none"
    owner                 = "tech-chapter-arquitectura"
    business_unit_project = "architecture"
    compliance            = "none"
    budget                = "none"
  }
}

# --- IAM Role for Lambda ---
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.resource_prefix}-lambda-exec-role"

  # Policy that allows Lambda to assume this role
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
  tags = local.common_tags
}

# Attach the basic Lambda execution policy (for CloudWatch Logs)
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# --- Lambda Function ---
# Archive the Python Lambda code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_function/" # Path to your Lambda code directory
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "api_lambda" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "${var.resource_prefix}-api-handler"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "app.lambda_handler" # Corresponds to app.py and function lambda_handler
  runtime       = "python3.9"        # Choose your Python runtime
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      GREETING = "Hello from Terraform-managed Lambda"
    }
  }
  tags = local.common_tags
}

# --- API Gateway ---
resource "aws_api_gateway_rest_api" "api" {
  name = "${var.resource_prefix}-api"
  description = "API Gateway with OpenAPI specification"
  
  body = file("${path.module}/openapi.yaml")

  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = local.common_tags
}

# --- API Gateway Deployment & Stage ---
# A deployment is required to make the API accessible
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  
  triggers = {
    redeployment = sha1(file("${path.module}/openapi.yaml"))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Stage for the deployment (e.g., dev, test, prod)
resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"
  tags = local.common_tags
}

# Add method settings for throttling
resource "aws_api_gateway_method_settings" "api_throttling" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  method_path = "*/*"  # This applies to all methods

  settings {
    throttling_burst_limit = 5
    throttling_rate_limit  = 10
  }
}

# --- Lambda Permission ---
# Allow API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" source ARN allows any method on any resource in this API to invoke the Lambda.
  # For more granular control, you can restrict this.
  # Example: arn:aws:execute-api:REGION:ACCOUNT_ID:API_ID/STAGE/METHOD/RESOURCE_PATH
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
