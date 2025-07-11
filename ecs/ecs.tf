resource "aws_ecs_cluster" "main" {
  name = "hello-world"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_service" "main" {
  name            = "web"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn

  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  desired_count                      = 1

  force_new_deployment = true

  network_configuration {
    security_groups  = [aws_security_group.app.id]
    subnets          = [aws_subnet.app.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "hello-world"
    container_port   = "3000"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_ecs_task_definition" "main" {
  family = "hello-world"
  cpu    = 256
  memory = 512

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "hello-world"
    image     = "crccheck/hello-world"
    essential = true

    portMappings = [{
      protocol      = "tcp"
      containerPort = 3000
    }]
  }])
}