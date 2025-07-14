
module "ssm_role" {
  source = "./modules/ssm-role"

  role_name              = "ec2_ssm_role"
  instance_profile_name  = "ec2_ssm_profile"
}


# EC2 instance to run hello-world Docker container
resource "aws_instance" "hello_world" {
  ami                         = data.aws_ami.amazon_linux.id # Amazon Linux 2 preferred
  instance_type               = "t3.micro"
  iam_instance_profile   = module.ssm_role.instance_profile_name
  subnet_id                   = aws_subnet.app.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user

              docker run -d -p ${var.app_port}:${var.app_port} crccheck/hello-world
              EOF

  tags = {
    Name = "HelloWorldEC2"
  }
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}