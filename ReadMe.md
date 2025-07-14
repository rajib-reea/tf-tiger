## 📚 Useful Resources

Here are some helpful references to extend and secure this infrastructure:

- 🔹 [**AWS ECS Blueprints (GitHub)**](https://github.com/aws-ia/ecs-blueprints)  
  *Best practices and examples for ECS at scale*

- 📘 [**Terraform Documentation**](https://developer.hashicorp.com/terraform/docs)  
  *Official documentation for resources, providers, and modules*

- 🛡️ [**Prowler - AWS Security Assessment Tool**](https://github.com/prowler-cloud/prowler)  
  *Run security scans and compliance checks on your AWS account*

---

### 🔑 Need to Remember

1. **Subnets** define *where* resources are placed in the VPC:  
   - Availability Zone  
   - IP range  

   **Security Groups** define *what traffic is allowed*, regardless of subnet:
   - Inbound and outbound rules

2. **Security Group (SG)** is a stateful virtual firewall that:
   - Controls **inbound and outbound traffic**
   - Is attached to **ENI-based resources** like EC2, ECS tasks (Fargate), ALB, RDS, etc.
   - Operates at the **instance level**

3. **Internet Gateway (IG)** and **NAT Gateway (NG)** are **VPC-wide components**:
   - They are **not ENI-based**
   - Therefore, **do not require security groups**

4. **ALB** and **Application instances** are **ENI-based**:
   - ✅ Must have **security groups**
   - 🔁 Security groups manage traffic **between ALB and app**


## 🚦 ALB Consideration for EC2 and Fargate

### 🔄 Target Group Behavior

Fargate:
  - Use `target_type = "ip"` in the ALB target group.
  - Fargate tasks are assigned ENIs with private IPs that are directly targeted.

EC2:
  - Use an explicit `aws_lb_target_group_attachment` to register the instance.

  ```hc
  resource "aws_lb_target_group_attachment" "web_attach" {
    target_group_arn = aws_lb_target_group.main.arn
    target_id        = aws_instance.hello_world.id
    port             = var.app_port
  }
```

## ⚙️ EC2 and Fargate IAM Requirements

- **Fargate** needs IAM roles:
  - Task Execution Role (for ECS agent permissions)
  - Task Role (for application permissions)

- **EC2** needs an SSM instance profile:
  - IAM Role attached to the EC2 instance
  - Allows Systems Manager (SSM) to manage the instance

