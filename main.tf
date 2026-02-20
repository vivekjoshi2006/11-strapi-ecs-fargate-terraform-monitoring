provider "aws" {
  region = "us-east-1"
}

# 1. ECR Repository
resource "aws_ecr_repository" "strapi" {
  name                 = "strapi-ecs-fargate-terraform-monitoring"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

# 2. CloudWatch Log Group
resource "aws_cloudwatch_log_group" "strapi_logs" {
  name              = "/ecs/strapi"
  retention_in_days = 7
}

# 3. Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

# 4. Security Group
resource "aws_security_group" "strapi_sg" {
  name   = "strapi-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 5. ECS Cluster with Monitoring Enabled
resource "aws_ecs_cluster" "main" {
  name = "strapi-cluster-v3"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# 6. Task Definition
resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = "arn:aws:iam::811738710312:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::811738710312:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "811738710312.dkr.ecr.us-east-1.amazonaws.com/strapi-ecs-fargate-terraform-monitoring:latest"
      essential = true
      portMappings = [{ containerPort = 1337, hostPort = 1337 }]
      
      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "APP_KEYS", value = "1234567890123456,1234567890123456" },
        { name = "API_TOKEN_SALT", value = "task7monitoringSalt" },
        { name = "ADMIN_JWT_SECRET", value = "task7monitoringSecret" },
        { name = "TRANSFER_TOKEN_SALT", value = "task7transferSalt" },
        { name = "JWT_SECRET", value = "task7jwtSecret" }
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

# 7. ECS Service
resource "aws_ecs_service" "main" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.strapi.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.strapi_sg.id]
    assign_public_ip = true
  }
}

resource "aws_cloudwatch_dashboard" "strapi_metrics" {
  dashboard_name = "Strapi-Monitoring-Vivek"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric", x = 0, y = 0, width = 12, height = 6,
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "CpuUtilized", "ClusterName", "strapi-cluster-v3", "ServiceName", "strapi-service"]
          ],
          period = 300, stat = "Average", region = "us-east-1",
          title = "CPU Utilization (%)"
        }
      },
      {
        type = "metric", x = 12, y = 0, width = 12, height = 6,
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "MemoryUtilized", "ClusterName", "strapi-cluster-v3", "ServiceName", "strapi-service"]
          ],
          period = 300, stat = "Average", region = "us-east-1",
          title = "Memory Utilization (MB)"
        }
      }
    ]
  })
}