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
