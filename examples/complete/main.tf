provider "aws" {
  region = var.region
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Example     = "complete"
  }
}

# Attach AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

  depends_on = [aws_iam_role.ecs_execution_role]
}

# ECS Task Role (for containers to access AWS services)
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Example     = "complete"
  }
}

# Optional: Add a sample policy for the task role (containers can access CloudWatch logs)
resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "ecs-task-policy-${var.environment}"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

module "ecs_task_definition" {
  source = "../.."

  family                   = "example-task-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  # Ephemeral storage
  ephemeral_storage = {
    size_in_gib = 30
  }

  # Runtime platform
  runtime_platform = {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  # Container definitions
  container_definitions = [
    {
      name      = "nginx"
      image     = "nginx:alpine"
      cpu       = 256
      memory    = 512
      essential = true

      environment = [
        {
          name  = "ENVIRONMENT"
          value = var.environment
        },
        {
          name  = "LOG_LEVEL"
          value = "info"
        }
      ]

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
          name          = "http"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/example-task"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "nginx"
          "awslogs-create-group"  = "true"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost/ || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    },
    {
      name      = "sidecar"
      image     = "busybox:latest"
      cpu       = 128
      memory    = 256
      essential = false

      command = ["sh", "-c", "while true; do echo Hello from sidecar; sleep 60; done"]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/example-task"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "sidecar"
          "awslogs-create-group"  = "true"
        }
      }

      dependsOn = [
        {
          containerName = "nginx"
          condition     = "HEALTHY"
        }
      ]
    }
  ]

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Example     = "complete"
  }
}
