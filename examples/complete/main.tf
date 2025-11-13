provider "aws" {
  region = var.region
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.execution_role_name_prefix}-${var.environment}"

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
    Example     = var.example_name
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
  name = "${var.task_role_name_prefix}-${var.environment}"

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
    Example     = var.example_name
  }
}

# Optional: Add a sample policy for the task role (containers can access CloudWatch logs)
resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "${var.task_policy_name_prefix}-${var.environment}"
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

  family                   = "${var.task_family_prefix}-${var.environment}"
  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  # Ephemeral storage
  ephemeral_storage = {
    size_in_gib = var.ephemeral_storage_size
  }

  # Runtime platform
  runtime_platform = {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  # Container definitions
  container_definitions = var.container_definitions

  tags = var.task_tags
}
