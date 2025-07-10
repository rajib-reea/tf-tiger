Make sure-
```
1. terraform is installed
2. aws cli is installed
```

Create Infrastructure:
```
1. terraform init
2. terraform fmt
3. terraform validate
4. terraform plan -out=infra.plan
5. terraform apply infra.plan
```

Destory Infrastructure:
```
1. terraform destroy -auto-approve
```
ECS:

```
1. First we make provider. In our case this is aws provider.
We can make KMS Key programmatically using Terraform that will be used in backend.
The problem is backend is being used during terraform initialization.
Therefore, we can break the provider code into-
bootstrap
main
and then use a shell script to make the provider.
Or we can use provider.tf directly after manually creating KMS Key.
```
