resource "aws_ecs_cluster" "blog" {
  name = var.name
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

  load_balancer {
    target_group_arn = aws_lb_target_group.blog.arn
    container_name   = var.name
    container_port   = 3000
  }
}

resource "aws_ecs_task_definition" "blog" {
  family = var.name
  container_definitions = jsonencode([
    {
      name      = var.name
      image     = var.image
      cpu       = 10
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