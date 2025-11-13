# Sample variables for running the complete example
# IAM roles are now created automatically by the example

# AWS region where resources will be created
region = "us-east-1"

# Environment name for resource naming and tagging
environment = "dev"

# Task family prefix
task_family_prefix = "example-task"

# Compatibility requirements
requires_compatibilities = ["FARGATE"]

# Network mode
network_mode = "awsvpc"

# CPU and memory
cpu    = "512"
memory = "1024"

# Ephemeral storage
ephemeral_storage_size = 30

# Runtime platform
operating_system_family = "LINUX"
cpu_architecture        = "X86_64"

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
        value = "dev"
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
        "awslogs-region"        = "us-east-1"
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
        "awslogs-region"        = "us-east-1"
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

# Tags for task definition
task_tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
  Example     = "complete"
}

# IAM role name prefixes
execution_role_name_prefix = "ecs-execution-role"
task_role_name_prefix      = "ecs-task-role"

# Policy name prefixes
execution_policy_name_prefix = "ecs-execution-policy"
task_policy_name_prefix      = "ecs-task-policy"

# Example name
example_name = "complete"
