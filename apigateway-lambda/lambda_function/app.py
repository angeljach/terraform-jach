# lambda_function/app.py
# This is a simple Lambda function that will be triggered by API Gateway.

import json

def lambda_handler(event, context):
    """
    Handles the incoming request from API Gateway.
    
    Args:
        event (dict): API Gateway Lambda Proxy Input Format
                      (https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format)
        context (object): Lambda Context runtime methods and attributes
                          (https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html)
                          
    Returns:
        dict: API Gateway Lambda Proxy Output Format
              (https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-output-format)
    """
    
    print("Lambda function invoked!")
    print("Event received:", json.dumps(event)) # Log the incoming event for debugging
    
    # Extract query string parameters if any (example)
    # query_params = event.get('queryStringParameters')
    # name = "World"
    # if query_params and 'name' in query_params:
    #     name = query_params['name']
        
    # Basic response
    body_message = {
        "message": "Hello from Lambda!",
        "input": event  # Echoing back the input event for demonstration
    }
    
    response = {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*" # Enable CORS for broad accessibility (customize for production)
        },
        "body": json.dumps(body_message)
    }
    
    return response

# Example usage for local testing (optional)
if __name__ == "__main__":
    # Simulate an API Gateway event
    mock_event = {
        "httpMethod": "GET",
        "path": "/hello",
        "queryStringParameters": {"name": "TestUser"},
        "headers": {"Content-Type": "application/json"}
    }
    mock_context = {}
    print(lambda_handler(mock_event, mock_context))
