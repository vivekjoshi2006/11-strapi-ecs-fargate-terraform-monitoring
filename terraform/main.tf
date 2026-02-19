# Create the Log Group so Strapi has a place to "talk"
resource "aws_cloudwatch_log_group" "strapi" {
  name              = "/ecs/strapi"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "main" {
  name = "strapi-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# 2. ECS Cluster with Container Insights (Metrics)
resource "aws_ecs_cluster" "main" {
  name = "strapi-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# 3. ECS Task Definition with Logging Configuration
resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "${aws_ecr_repository.strapi.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/strapi"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}