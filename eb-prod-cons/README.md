# Ejecución
1. Zip all py files
Be careful to zip without the lambdas directory, zip directly using something like
```shell
cd lambdas
zip sn_producer.py.zip sn_producer.py
```

2. Execute the following commands:
```shell
aws sso login --sso-session 598341739583
terraform init
terraform plan
terraform apply
```
3. Destroy
```shell
terraform destroy
```

# Logic
sn_producer.py generates an event that sn_consumer1.py and sn_consumer2.py catch because they are suscribed to a rule that match with the event sent. After that, the consumers print the logic added to them in order to simulate a points transfer between aliadito to client and client to aliadito.

## Arquitectura
![Event Bridge - Producer:Consumers](../image/eb-prod-cons.png)

Evento ocupado en la prueba
```json
{
  "version": "0",
  "id": "UUID",
  "detail-type": "transaction.persisted",
  "source": "sn.app",
  "account": "598341739583",
  "time": "timestamp",
  "region": "us-east-1",
  "resources": [],
  "detail": {
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
    "payment_concept": "Mandado"
  }
}
```