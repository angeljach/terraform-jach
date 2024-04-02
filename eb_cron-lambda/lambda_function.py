import json

'''
In this function, event is the input to the Lambda function, which you can use to
pass custom values. The context object contains information about the runtime the
Lambda function is using. The function prints the "Hello, World!" message and
returns a response with a status code and the printed message.
'''
def lambda_handler(event, context):
    message = "Hello, World!"
    print(message)
    return {
        'statusCode': 200,
        'body': json.dumps('Printed message: ' + message)
    }