resource "aws_security_group" "alb" {
  name   = "hello-world-alb"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = var.alb_port
    to_port          = var.alb_port
    cidr_blocks      = local.all_ipv4
    ipv6_cidr_blocks = local.all_ipv6
  }

  egress {
    protocol         = "tcp"
    from_port        = var.app_port
    to_port          = var.app_port
    cidr_blocks      = local.all_ipv4
    ipv6_cidr_blocks = local.all_ipv6
  }
}

resource "aws_security_group" "app" {
  name   = "hello-world-app"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = var.app_port
    to_port          = var.app_port
    cidr_blocks      = local.all_ipv4
    ipv6_cidr_blocks = local.all_ipv6
  }

  egress {
    protocol         = "-1"
    from_port        = var.all_port
    to_port          = var.all_port
    cidr_blocks      = local.all_ipv4
    ipv6_cidr_blocks = local.all_ipv6
  }
}
