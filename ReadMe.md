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
A. Provider
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

B. VPC and Subnet:
```
1. Create VPC
2. Create EIP
3. Create IG
4. Create NG (allocation_id is basically created EIP and this depends on IG)
5. Create subnets for nat, app, alb_1 and alb_2
```
C. Routing:
```
1. Create Public Route Table
2. Create Private Route Table
3. Attach IG with Public Route Table- a Public Route
4. Attach NG with Private Route Table- a Private Route
5. Attach Public Route with nat, alb_1 and alb_2
6. Attach Private Route with app
```
D. IAM:
```
1. Make Policy Document for ECS Assume Role
2. Make Policy Document for App Access
3. Create Task Role
4. Create Task Execution Role
5. Attach Task Execution Role with ECS Assume Role Policy Document
6. Make a Policy to attach App Access
7. Attach App Policy
```
