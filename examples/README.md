# ECS Task Definition Module Examples

This directory contains comprehensive examples demonstrating the capabilities of the ECS task definition module. Each example showcases different use cases and configuration patterns.

## Available Examples

### 1. [Complete](./complete/)
**Comprehensive ECS task definition with all features**
- FARGATE launch type configuration
- Container definitions with multiple settings
- ECS execution role and task role setup
- Ephemeral storage configuration
- Runtime platform specification
- Volume configuration (host, Docker, EFS)
- Placement constraints
- CloudWatch logging integration
- Sample IAM policies for containers

## Features Demonstrated

### Core Module Features
- ✅ **Family naming**: Task definition family and versioning
- ✅ **Launch types**: FARGATE and EC2 compatibility
- ✅ **Network modes**: awsvpc configuration for Fargate
- ✅ **CPU and memory**: Resource allocation
- ✅ **IAM roles**: Execution role and task role setup
- ✅ **Container definitions**: Container configuration and settings
- ✅ **Ephemeral storage**: Temporary storage allocation

### Advanced Features
- ✅ **Runtime platform**: Operating system and CPU architecture selection
- ✅ **Placement constraints**: Constraint-based task placement
- ✅ **Volumes**: EFS, Docker, and host path volumes
- ✅ **Proxy configuration**: App Mesh integration support
- ✅ **IPC and PID modes**: Namespace configuration
- ✅ **Fault injection**: AWS Resilience Hub integration
- ✅ **Tags**: Comprehensive tagging for resource organization

### IAM Integration
- ✅ **Task execution role**: Pull images and CloudWatch logs
- ✅ **Task role**: Container application permissions
- ✅ **Inline policies**: Custom permissions for containers
- ✅ **AWS managed policies**: Standard role policies

## Running the Examples

Each example includes:
- `main.tf`: Module usage and supporting resources
- `variables.tf`: Configurable parameters with defaults
- `outputs.tf`: Useful outputs for integration
- `versions.tf`: Provider requirements
- `terraform.tfvars`: Example variable values

### Quick Start

```bash
# Navigate to the example
cd examples/complete

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan

# Apply configuration (requires AWS credentials)
terraform apply
```

### Validating Examples

```bash
# Validate the complete example
cd examples/complete
terraform init -backend=false
terraform validate
```

## Module Capability Coverage

The complete example provides comprehensive coverage:

- **Core ECS task definition** functionality
- **FARGATE** launch type configuration
- **IAM role** setup and permissions
- **Container definitions** with multiple configurations
- **Volume management** (host, Docker, EFS)
- **Runtime platform** customization
- **Logging and monitoring** integration
- **Best practices** for production deployments
