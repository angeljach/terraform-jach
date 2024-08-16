import json
import boto3

def lambda_handler(event, context):
    eventbridge = boto3.client('events')

    response = eventbridge.put_events(
        Entries=[
            {
                'Source': 'sn.app',
                'DetailType': 'transaction',
                'Detail': json.dumps(
                    {
                    "aliadito": {
                        "ciam": "autth0|aa35232bd3"
                    },
                    "store": {
                        "id": "37",
                        "name": "Abarrotes Don Pedro"
                    },
                    "client": {
                        "premia_card": "1111222233334444",
                        "telephone": "5534539926"
                    },
                    "transactions": [{
                        "payment_type": "EF",
                        "total": 200.00,
                        "points_to_aliadito": 0,
                        "points_to_client": 40
                        },
                        {
                        "payment_type": "PP",
                        "total": 300.00,
                        "points_to_aliadito": 3000,
                        "points_to_client": 0
                        }
                    ],
                    "total": 500.00,
                    "points_to_aliadito": 3000,
                    "points_to_client": 40,
                    "payment_concept": "Alimentos",
                }
                    ),
                'EventBusName': 'event-bus'
            }
        ]
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Events Sent!')
    }
