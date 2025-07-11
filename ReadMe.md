0. Create Profile
```
1. create/configure:
aws configure --profile infra-profile
2. check:
aws sts get-caller-identity --profile infra-profile
```

I. Ready an EC2 Infrastructure:
```
1. terraform is installed
2. aws cli is installed
```

A. Create Infrastructure:
```
1. terraform init
2. terraform fmt
3. terraform validate
4. terraform plan -out=infra.plan
5. terraform apply infra.plan
```

B. Destory Infrastructure:
```
1. terraform destroy -auto-approve
```

II. Run an Application on ECS:
```
Need to remember-
1. Subnets define where resources are placed in the VPC (e.g., availability zone, IP range).
and
Security groups define what traffic is allowed to/from resources, regardless of subnet.

2. A Security Group (SG) is a stateful virtual firewall that:

Controls inbound and outbound traffic

Is attached to ENI-based resources like EC2, ECS tasks (Fargate), Load Balancers, RDS, etc.

Operates at the instance level

Internet Gateway(IG) and NAT Gateway(NG) are VPC-wide networking components — not ENI-based instances
and
ALB and App are ENI-based. Therfore, ALB and App need Security Groups while IG and NG do not need.
```

Create KMS Key:
```
aws kms create-key --description "Infra KMS key" --region us-east-1 --profile infra-profile
aws secretsmanager list-secrets --profile infra-profile --query "SecretList[*].Name" --output text
[the above command is to get key name prefix. in my case i have not get any prefix.]

```

Create S3 Bucket:
```
aws s3api create-bucket --bucket infra-s3 --profile infra-profile
[
for us-east-1; unfortunately it does not work because this region is a special region. I  have created manually.
]
aws s3api create-bucket --bucket infra-s3 --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2 --profile infra-profile
[for any other region except us-east-1; create-bucket-configuration is a must requirement.]
```
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
  from_port       = 3000
  to_port         = 3000
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

F. IAM:
```
1. Make Policy Document for ECS Assume Role
2. Make Policy Document for App Access
3. Make a Policy to attach App Access
4. Create Task Role
5. Create Task Execution Role
6. Attach Task Execution Role with ECS Assume Role Policy Document
```

G. ECS
```
1. Create ECS Cluster (this involves setting)
2. Create a Task Definition (this involves container_definitions)
[
network_mode = "awsvpc" requires_compatibilities = ["FARGATE"] for fargate
network_mode = "bridge" requires_compatibilities = ["EC2"] for ec2
]
3. Create ECS Service (this involves network_configuration, load_balancer and lifecycle)
[
launch_type = "FARGATE" for fargate
launch_type = "EC2" for ec2
]
run:
check tasks: aws ecs describe-services --cluster hello-world --services web --profile infra-profile
check failed tasks: aws ecs describe-tasks --cluster hello-world --tasks $(aws ecs list-tasks --cluster hello-world --service web --query 'taskArns' --output text --profile infra-profile) --profile infra-profile
check alb health: aws elbv2 describe-target-health \
  --target-group-arn $(aws elbv2 describe-target-groups \
    --names your-target-group-name \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text \
    --profile infra-profile) \
  --profile infra-profile
```
