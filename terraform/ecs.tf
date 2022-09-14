resource "aws_ecs_cluster" "blog" {
  name = var.name
}

resource "aws_ecr_repository" "blog" {
  name = var.name
}

resource "aws_iam_role" "task" {
  name = "${var.name}-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task" {
  role       = aws_iam_role.task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster_capacity_providers" "fargate" {
  cluster_name = aws_ecs_cluster.blog.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_service" "blog" {
  name            = var.name
  cluster         = aws_ecs_cluster.blog.id
  task_definition = aws_ecs_task_definition.blog.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.blog.arn
    container_name   = var.name
    container_port   = 3000
  }

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [aws_security_group.blog.id]
  }
}

resource "aws_ecs_task_definition" "blog" {
  family                   = var.name
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task.arn
  container_definitions = jsonencode([
    {
      name      = var.name
      image     = "${aws_ecr_repository.blog.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      environment = [
        {
          "name" : "DATABASE_HOST",
          "value" : aws_db_instance.blog.address
        },
        {
          "name" : "DATABASE_DB",
          "value" : aws_db_instance.blog.db_name
        },
        {
          "name" : "DATABASE_USER",
          "value" : aws_db_instance.blog.username
        },
        {
          "name" : "DATABASE_PASSWORD",
          "value" : random_password.db.result
        }
      ]
    }
  ])
}