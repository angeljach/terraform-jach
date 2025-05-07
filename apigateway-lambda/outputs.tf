# outputs.tf
output "api_gateway_invoke_url" {
  description = "The invoke URL for the deployed API Gateway stage."
  # The URL format is: https://{restapi_id}.execute-api.{region}.amazonaws.com/{stage_name}/
  value       = "${aws_api_gateway_stage.api_stage.invoke_url}${aws_api_gateway_resource.hello_resource.path_part}"
  # Note: aws_api_gateway_deployment.invoke_url is deprecated. Use aws_api_gateway_stage.invoke_url
}

output "lambda_function_name" {
  description = "The name of the created Lambda function."
  value       = aws_lambda_function.api_lambda.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the created Lambda function."
  value       = aws_lambda_function.api_lambda.arn
}

output "api_gateway_id" {
  description = "The ID of the API Gateway REST API."
  value       = aws_api_gateway_rest_api.my_api.id
}