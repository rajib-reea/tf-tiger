Steps to Check:
````
1. check app port
2. change in securty-group
3. change in alb target group
4. change in ec2
````
Get Instance ID:
````
aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].[InstanceId, PublicIpAddress, Tags[?Key=='Name']|[0].Value]" \
  --output table \
  --profile infra-profile

````
Route Table:
```
aws ec2 describe-route-tables
```

Run an Application on ECS:

See AZs:
```
aws ec2 describe-availability-zones --region us-east-1 --profile infra-profile --query "AvailabilityZones[*].ZoneName" --output text
```

A. Provider
```
1. Create provider
run: terraform init
[
As KMS key is a secret, we do not like to hardcode it.
]
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

D. Security Group:
```
1. Create Security Group for alb
2. Create Security Group for app
[
we can restrict app access only from alb
ingress {
  from_port       = 8000
  to_port         = 8000
  protocol        = "tcp"
  security_groups = [aws_security_group.alb.id]
}

]
```
E. ALB:
```
1. Create alb
2. Create a Listener for alb
3. Create a Target Group for alb (target_type=ip for fargate and target_type=instance for ec2)
run to get alb dns name:
aws elbv2 describe-load-balancers --query 'LoadBalancers[*].DNSName' --region us-east-1 --profile infra-profile
curl alb_dns_name
```

F. EC2:
```
1. Create ec2 instance
```

Destory Infrastructure:
```
terraform destroy -auto-approve
```
