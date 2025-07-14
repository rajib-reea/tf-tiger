resource "aws_lb" "main" {
  name               = "hello-world-web"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.alb_a.id,
    aws_subnet.alb_c.id
  ]

  internal                   = false
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "main" {
  name        = "hello-world-web"
  protocol    = "HTTP"
  port        = var.app_port
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    protocol            = "HTTP"
    matcher             = "200"
    path                = "/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  protocol          = "HTTP"
  port              = var.alb_port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
