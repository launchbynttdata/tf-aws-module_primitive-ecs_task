// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

# ============================================
# ECS TASK DEFINITION PRIMITIVE OUTPUTS
# ============================================

# Task Definition Core Outputs
output "arn" {
  description = "The ARN of the ECS task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "arn_without_revision" {
  description = "The ARN of the ECS task definition without revision"
  value       = aws_ecs_task_definition.this.arn_without_revision
}

output "family" {
  description = "The family of the ECS task definition"
  value       = aws_ecs_task_definition.this.family
}

output "revision" {
  description = "The revision of the ECS task definition"
  value       = aws_ecs_task_definition.this.revision
}

output "enable_fault_injection" {
  description = "Whether fault injection is enabled for the task definition"
  value       = aws_ecs_task_definition.this.enable_fault_injection
}

# Task Definition Configuration Outputs
output "network_mode" {
  description = "The Docker networking mode used by the task"
  value       = aws_ecs_task_definition.this.network_mode
}

output "requires_compatibilities" {
  description = "The launch types required by the task"
  value       = aws_ecs_task_definition.this.requires_compatibilities
}

output "cpu" {
  description = "The number of CPU units used by the task"
  value       = aws_ecs_task_definition.this.cpu
}

output "memory" {
  description = "The amount of memory (in MiB) used by the task"
  value       = aws_ecs_task_definition.this.memory
}

# IAM Role Outputs
output "execution_role_arn" {
  description = "The ARN of the task execution role"
  value       = aws_ecs_task_definition.this.execution_role_arn
}

output "task_role_arn" {
  description = "The ARN of the task role"
  value       = aws_ecs_task_definition.this.task_role_arn
}

# Container Information
output "container_names" {
  description = "List of container names in the task definition"
  value       = local.container_names
}

output "container_definitions" {
  description = "The container definitions in JSON format"
  value       = local.container_definitions_json
  sensitive   = true
}

# Tags
output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ecs_task_definition.this.tags_all
}

# Additional Attributes
output "track_latest" {
  description = "Whether the ECS service tracks the latest ACTIVE revision"
  value       = aws_ecs_task_definition.this.track_latest
}

output "placement_constraints" {
  description = "The placement constraints for the task"
  value       = var.placement_constraints
}

output "volumes" {
  description = "The volume configuration for the task"
  value       = var.volumes
}
