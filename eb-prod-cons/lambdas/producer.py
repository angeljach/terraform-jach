import json
import boto3

def lambda_handler(event, context):
    eventbridge = boto3.client('events')

    response = eventbridge.put_events(
        Entries=[
            {
                'Source': 'custom.producer',
                'DetailType': 'event-for-consumer1',
                'Detail': json.dumps({'message': 'Hello Consumer 1'}),
                'EventBusName': 'event-bus'
            },
            {
                'Source': 'custom.producer',
                'DetailType': 'event-for-consumer2',
                'Detail': json.dumps({'message': 'Hello Consumer 2'}),
                'EventBusName': 'event-bus'
            }
        ]
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Events Sent!')
    }
